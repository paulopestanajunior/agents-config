# Validate harness components: frontmatter, delegation edges, cycles, and
# unqualified boundary labels. No external dependencies.

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoDir

$script:Errors = 0
$script:Warnings = 0

function Write-Err {
    param([Parameter(Mandatory)] [string]$Message)
    $script:Errors++
    Write-Host "ERROR: $Message"
}

function Write-Warn {
    param([Parameter(Mandatory)] [string]$Message)
    $script:Warnings++
    Write-Host "WARN:  $Message"
}

# ---------------------------------------------------------------------------
# Component inventory.
# ---------------------------------------------------------------------------

$components = New-Object System.Collections.Generic.HashSet[string]

Get-ChildItem -Path "skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName "SKILL.md")) {
        [void]$components.Add($_.Name)
    }
}

foreach ($dir in @("roles", "workflows", "profiles", "rules")) {
    Get-ChildItem -Path $dir -Filter "*.md" -File -ErrorAction SilentlyContinue | ForEach-Object {
        [void]$components.Add($_.BaseName)
    }
}

# ---------------------------------------------------------------------------
# 1. Frontmatter: name present, matches directory; description present.
# ---------------------------------------------------------------------------

Get-ChildItem -Path "skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) { return }

    $rel = "skills/$($_.Name)/SKILL.md"
    $lines = Get-Content $skillFile

    if ($lines.Count -eq 0 -or $lines[0].Trim() -ne "---") {
        Write-Err "${rel}: missing YAML frontmatter"
        return
    }

    $closing = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq "---") { $closing = $i; break }
    }
    if ($closing -lt 0) {
        Write-Err "${rel}: unterminated frontmatter"
        return
    }

    $front = $lines[1..($closing - 1)]
    $nameLine = $front | Where-Object { $_ -match '^name:\s*(.+)$' } | Select-Object -First 1

    if (-not $nameLine) {
        Write-Err "${rel}: frontmatter has no 'name'"
    } else {
        $declared = ($nameLine -replace '^name:\s*', '').Trim()
        if ($declared -ne $_.Name) {
            Write-Err "${rel}: frontmatter name '$declared' does not match directory '$($_.Name)'"
        }
    }

    if (-not ($front | Where-Object { $_ -match '^description:' })) {
        Write-Err "${rel}: frontmatter has no 'description'"
    }
}

# ---------------------------------------------------------------------------
# 2. Delegation edges resolve to an existing component.
# ---------------------------------------------------------------------------

function Get-UnwrappedBullets {
    param([Parameter(Mandatory)] [string]$Path)

    $out = New-Object System.Collections.Generic.List[string]
    $buf = ""

    foreach ($line in (Get-Content $Path)) {
        if ($line -match '^\s*[-*]\s') {
            if ($buf -ne "") { $out.Add($buf) }
            $buf = $line
        } elseif ($line -match '^\s+\S' -and $buf -ne "") {
            $buf = $buf + " " + $line.TrimStart()
        } else {
            if ($buf -ne "") { $out.Add($buf); $buf = "" }
            $out.Add($line)
        }
    }
    if ($buf -ne "") { $out.Add($buf) }

    return $out
}

$edges = New-Object System.Collections.Generic.HashSet[string]

$sources = @()
Get-ChildItem -Path "skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $p = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $p) { $sources += [pscustomobject]@{ Path = $p; Origin = $_.Name; Rel = "skills/$($_.Name)/SKILL.md" } }
}
Get-ChildItem -Path "roles" -Filter "*.md" -File -ErrorAction SilentlyContinue | ForEach-Object {
    $sources += [pscustomobject]@{ Path = $_.FullName; Origin = $_.BaseName; Rel = "roles/$($_.Name)" }
}

foreach ($src in $sources) {
    foreach ($bullet in (Get-UnwrappedBullets -Path $src.Path)) {
        foreach ($m in [regex]::Matches($bullet, '->\s+([A-Z][^.;]*)')) {
            $raw = $m.Groups[1].Value
            foreach ($target in ($raw -split '\s+or\s+')) {
                $t = $target.Trim()
                if ($t -eq "") { continue }

                $slug = $t.ToLower() -replace '/', '-' -replace '\s+', '-'
                switch ($slug) {
                    "ai-engineer" { $slug = "ai-ml-engineer" }
                    "tracking-integrations-qa" { $slug = "qa-tracking-integrations" }
                }

                if ($components.Contains($slug)) {
                    [void]$edges.Add("$($src.Origin) -> $slug")
                } else {
                    Write-Err "$($src.Rel): delegation target `"$t`" ($slug) does not resolve to a component"
                }
            }
        }
    }
}

# ---------------------------------------------------------------------------
# 3. Mutual delegation between two components.
# ---------------------------------------------------------------------------

foreach ($edge in $edges) {
    $parts = $edge -split ' -> '
    $a = $parts[0]; $b = $parts[1]
    if ($edges.Contains("$b -> $a") -and ([string]::Compare($a, $b) -lt 0)) {
        Write-Warn "mutual delegation between '$a' and '$b': verify both bullets name a distinct sub-object"
    }
}

# ---------------------------------------------------------------------------
# 4. Boundary bullets must name a sub-object, not a bare domain label.
# ---------------------------------------------------------------------------

foreach ($src in $sources) {
    if ($src.Rel -notlike "skills/*") { continue }

    foreach ($bullet in (Get-UnwrappedBullets -Path $src.Path)) {
        if ($bullet -notmatch '->') { continue }
        $lower = $bullet.ToLower()

        if ($lower -match '(^|[^a-z-])drift' -and
            $lower -notmatch '(production|data|concept|schema|infra|infrastructure)\s+drift') {
            Write-Warn "$($src.Rel): bare label 'drift' in a delegation bullet; qualify it (production/data/concept/schema)"
        }

        if ($bullet -cmatch '(^|[^a-zA-Z-])RAG' -and
            $bullet -notmatch '(RAG corpus|RAG pipeline|inside agentic|Agent/RAG/model)') {
            Write-Warn "$($src.Rel): bare label 'RAG' in a delegation bullet; name the sub-object (corpus vs per-turn retrieval)"
        }

        if ($lower -match 'feature store' -and $lower -notmatch 'as a (served )?data product') {
            Write-Warn "$($src.Rel): bare label 'feature store' in a delegation bullet; name the sub-object (definition/table/serving)"
        }
    }
}

# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "$($components.Count) components, $($edges.Count) edges checked. $script:Errors error(s), $script:Warnings warning(s)."

if ($script:Errors -gt 0) { exit 1 }

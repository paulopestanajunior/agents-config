$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$GeneratedAt = "Generated from the canonical agents-config directories. Do not edit by hand."
$CatalogPt = Join-Path $RepoDir "docs/catalog.pt.tsv"
$CatalogAnnotations = @{}
if (Test-Path $CatalogPt) {
    Import-Csv -Path $CatalogPt -Delimiter "`t" | ForEach-Object {
        $CatalogAnnotations["$($_.Type)`n$($_.Name)"] = $_
    }
}

function Get-Title {
    param([Parameter(Mandatory)] [string]$Path)
    $line = Get-Content $Path | Where-Object { $_ -match '^# ' } | Select-Object -First 1
    if ($line) { return ($line -replace '^# ', '') }
    if ([System.IO.Path]::GetFileName($Path) -eq "SKILL.md") {
        return (Split-Path -Leaf (Split-Path -Parent $Path))
    }
    return [System.IO.Path]::GetFileNameWithoutExtension($Path)
}

function Get-RelativePath {
    param([Parameter(Mandatory)] [string]$Path)
    return [System.IO.Path]::GetRelativePath($RepoDir, $Path).Replace('\', '/')
}

function Get-SkillLines {
    $skillsDir = Join-Path $RepoDir "skills"
    if (-not (Test-Path $skillsDir)) { return @() }
    Get-ChildItem $skillsDir -Directory | Sort-Object Name | ForEach-Object {
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) {
            $title = Get-Title -Path $skillFile
            $rel = Get-RelativePath -Path $skillFile
            '- `{0}` - {1} (`{2}`)' -f $_.Name, $title, $rel
        }
    }
}

function Get-MarkdownLines {
    param([Parameter(Mandatory)] [string]$Directory)
    $dir = Join-Path $RepoDir $Directory
    if (-not (Test-Path $dir)) { return @() }
    Get-ChildItem $dir -File -Filter "*.md" | Sort-Object Name | ForEach-Object {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $title = Get-Title -Path $_.FullName
        $rel = Get-RelativePath -Path $_.FullName
        '- `{0}` - {1} (`{2}`)' -f $name, $title, $rel
    }
}

function Get-TableCell {
    param([AllowNull()] [string]$Value)
    if (-not $Value) { return "" }
    return (($Value -replace '\|', '\|' -replace '\s+', ' ').Trim())
}

function Get-SkillDescription {
    param([Parameter(Mandatory)] [string]$Path)
    $lines = Get-Content $Path
    $inDescription = $false
    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match '^description:\s*>-') {
            $inDescription = $true
            continue
        }
        if ($inDescription -and $line -match '^  ') {
            $parts.Add(($line -replace '^  ', ''))
            continue
        }
        if ($inDescription -and $line -notmatch '^  ') {
            break
        }
    }
    return (($parts -join ' ') -replace '\s+', ' ').Trim()
}

function Get-FirstParagraph {
    param([Parameter(Mandatory)] [string]$Path)
    $lines = Get-Content $Path
    $inFrontmatter = $false
    $parts = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($i -eq 0 -and $line -eq "---") {
            $inFrontmatter = $true
            continue
        }
        if ($inFrontmatter -and $line -eq "---") {
            $inFrontmatter = $false
            continue
        }
        if ($inFrontmatter -or $line -match '^#') {
            continue
        }
        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($parts.Count -gt 0) { break }
            continue
        }
        $parts.Add($line.Trim())
    }
    return (($parts -join ' ') -replace '\s+', ' ').Trim()
}

function Get-AvoidText {
    param([Parameter(Mandatory)] [string]$Type)
    switch ($Type) {
        "Skill" { "Use outro especialista quando a tarefa estiver fora desta expertise." }
        "Role" { "Use skill/workflow/profile quando precisar apenas de expertise, sequência ou profundidade." }
        "Workflow" { "Evite quando a tarefa não seguir esta sequência de execução." }
        "Profile" { "Evite quando a profundidade, autonomia ou postura de risco pedida for diferente." }
        "Rule" { 'Não ignore silenciosamente; documente exceções específicas do projeto em `.agents/overrides/`.' }
    }
}

function Get-DefaultPurpose {
    param(
        [Parameter(Mandatory)] [string]$Type,
        [Parameter(Mandatory)] [string]$Name
    )
    switch ($Type) {
        "Skill" { 'Skill `{0}`' -f $Name }
        "Role" { 'Role `{0}`' -f $Name }
        "Workflow" { 'Workflow `{0}`' -f $Name }
        "Profile" { 'Profile `{0}`' -f $Name }
        "Rule" { 'Rule `{0}`' -f $Name }
    }
}

function Get-DefaultWhen {
    param(
        [Parameter(Mandatory)] [string]$Type,
        [Parameter(Mandatory)] [string]$Name
    )
    switch ($Type) {
        "Skill" { 'Use quando a tarefa exigir a especialidade `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $Name }
        "Role" { 'Use quando a tarefa exigir a postura operacional `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $Name }
        "Workflow" { 'Use quando a tarefa seguir a sequência de execução `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $Name }
        "Profile" { 'Use quando a tarefa exigir a profundidade, autonomia ou postura de risco `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $Name }
        "Rule" { 'Use como restrição durável quando `{0}` for relevante para a tarefa ou projeto. Consulte o arquivo canônico para critérios detalhados.' -f $Name }
    }
}

function New-AnnotationObject {
    param(
        [Parameter(Mandatory)] [string]$Type,
        [Parameter(Mandatory)] [string]$Name
    )
    [PSCustomObject]@{
        Type = $Type
        Name = $Name
        Purpose = Get-DefaultPurpose -Type $Type -Name $Name
        When = Get-DefaultWhen -Type $Type -Name $Name
        Avoid = Get-AvoidText -Type $Type
    }
}

function Get-ExpectedCatalogAnnotations {
    $rows = New-Object System.Collections.Generic.List[object]
    $skillsDir = Join-Path $RepoDir "skills"
    if (Test-Path $skillsDir) {
        Get-ChildItem $skillsDir -Directory | Sort-Object Name | ForEach-Object {
            $skillFile = Join-Path $_.FullName "SKILL.md"
            if (Test-Path $skillFile) {
                $rows.Add((New-AnnotationObject -Type "Skill" -Name $_.Name))
            }
        }
    }
    foreach ($directory in @("roles", "workflows", "profiles", "rules")) {
        $dir = Join-Path $RepoDir $directory
        if (-not (Test-Path $dir)) { continue }
        Get-ChildItem $dir -File -Filter "*.md" | Sort-Object Name | ForEach-Object {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $type = switch ($directory) {
                "roles" { "Role" }
                "workflows" { "Workflow" }
                "profiles" { "Profile" }
                "rules" { "Rule" }
            }
            $rows.Add((New-AnnotationObject -Type $type -Name $name))
        }
    }
    return $rows
}

function Save-CatalogAnnotations {
    param([Parameter(Mandatory)] [object[]]$Rows)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $CatalogPt) | Out-Null
    $lines = @("Type`tName`tPurpose`tWhen`tAvoid")
    foreach ($row in $Rows) {
        $lines += "{0}`t{1}`t{2}`t{3}`t{4}" -f $row.Type, $row.Name, $row.Purpose, $row.When, $row.Avoid
    }
    Set-Content -Path $CatalogPt -Value $lines -Encoding UTF8
}

function Ensure-CatalogAnnotations {
    $expected = Get-ExpectedCatalogAnnotations
    if (-not (Test-Path $CatalogPt)) {
        Save-CatalogAnnotations -Rows $expected
        return
    }
    $existingByKey = @{}
    Import-Csv -Path $CatalogPt -Delimiter "`t" | ForEach-Object {
        $existingByKey["$($_.Type)`n$($_.Name)"] = $_
    }
    $merged = New-Object System.Collections.Generic.List[object]
    foreach ($row in $expected) {
        $key = "$($row.Type)`n$($row.Name)"
        if ($existingByKey.ContainsKey($key)) {
            $merged.Add($existingByKey[$key])
        } else {
            $merged.Add($row)
        }
    }
    Save-CatalogAnnotations -Rows $merged
}

function Get-Annotation {
    param(
        [Parameter(Mandatory)] [string]$Type,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Field
    )
    $key = "$Type`n$Name"
    if ($CatalogAnnotations.ContainsKey($key)) {
        return $CatalogAnnotations[$key].$Field
    }
    return ""
}

function New-CatalogRow {
    param(
        [Parameter(Mandatory)] [string]$Type,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Purpose,
        [Parameter(Mandatory)] [string]$When,
        [Parameter(Mandatory)] [string]$Path,
        [string]$Avoid = ""
    )
    $avoidText = if ($Avoid) { $Avoid } else { Get-AvoidText -Type $Type }
    '| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $Type, $Name, (Get-TableCell $Purpose), (Get-TableCell $When), (Get-TableCell $avoidText), $Path
}

function Write-Catalog {
    $output = Join-Path $RepoDir "docs/catalog.generated.md"
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $output) | Out-Null
    $lines = @(
        "# Catálogo Gerado De Componentes",
        "",
        "Gerado a partir dos diretórios canônicos do agents-config. Não edite manualmente.",
        "",
        'Fonte da verdade: `skills/*/SKILL.md`, `roles/*.md`, `workflows/*.md`, `profiles/*.md` e `rules/*.md`.',
        "",
        'Observação: nomes e caminhos vêm dos arquivos canônicos usados pelos agents. Os textos em português vêm de `docs/catalog.pt.tsv` quando existirem; novos componentes sem anotação aparecem com fallback em português.',
        "",
        "| Tipo | Nome | Finalidade | Quando Usar | Quando Evitar | Caminho |",
        "|---|---|---|---|---|---|"
    )

    $skillsDir = Join-Path $RepoDir "skills"
    if (Test-Path $skillsDir) {
        Get-ChildItem $skillsDir -Directory | Sort-Object Name | ForEach-Object {
            $skillFile = Join-Path $_.FullName "SKILL.md"
            if (Test-Path $skillFile) {
                $title = Get-Title -Path $skillFile
                $description = Get-SkillDescription -Path $skillFile
                if (-not $description) { $description = Get-FirstParagraph -Path $skillFile }
                $ptPurpose = Get-Annotation -Type "Skill" -Name $_.Name -Field "Purpose"
                $ptWhen = Get-Annotation -Type "Skill" -Name $_.Name -Field "When"
                $ptAvoid = Get-Annotation -Type "Skill" -Name $_.Name -Field "Avoid"
                if ($ptPurpose) { $title = $ptPurpose }
                if ($ptWhen) {
                    $description = $ptWhen
                } else {
                    $description = 'Use quando a tarefa exigir a especialidade `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $_.Name
                }
                $lines += New-CatalogRow -Type "Skill" -Name $_.Name -Purpose $title -When $description -Path (Get-RelativePath -Path $skillFile) -Avoid $ptAvoid
            }
        }
    }

    foreach ($directory in @("roles", "workflows", "profiles", "rules")) {
        $dir = Join-Path $RepoDir $directory
        if (-not (Test-Path $dir)) { continue }
        Get-ChildItem $dir -File -Filter "*.md" | Sort-Object Name | ForEach-Object {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $title = Get-Title -Path $_.FullName
            $summary = Get-FirstParagraph -Path $_.FullName
            if (-not $summary) { $summary = $title }
            $type = switch ($directory) {
                "roles" { "Role" }
                "workflows" { "Workflow" }
                "profiles" { "Profile" }
                "rules" { "Rule" }
            }
            $ptPurpose = Get-Annotation -Type $type -Name $name -Field "Purpose"
            $ptWhen = Get-Annotation -Type $type -Name $name -Field "When"
            $ptAvoid = Get-Annotation -Type $type -Name $name -Field "Avoid"
            if ($ptPurpose) { $title = $ptPurpose }
            if ($ptWhen) {
                $summary = $ptWhen
            } else {
                $summary = 'Use quando precisar do componente `{0}`. Consulte o arquivo canônico para critérios detalhados.' -f $name
            }
            $lines += New-CatalogRow -Type $type -Name $name -Purpose $title -When $summary -Path (Get-RelativePath -Path $_.FullName) -Avoid $ptAvoid
        }
    }

    Set-Content -Path $output -Value $lines -Encoding UTF8
}

function Get-ComponentSectionLines {
    $lines = @(
        "## Skills",
        ""
    )
    $lines += Get-SkillLines
    $lines += @("", "## Roles", "")
    $lines += Get-MarkdownLines -Directory "roles"
    $lines += @("", "## Workflows", "")
    $lines += Get-MarkdownLines -Directory "workflows"
    $lines += @("", "## Profiles", "")
    $lines += Get-MarkdownLines -Directory "profiles"
    $lines += @("", "## Rules", "")
    $lines += Get-MarkdownLines -Directory "rules"
    return $lines
}

function Write-ComponentIndex {
    param(
        [Parameter(Mandatory)] [string]$Output,
        [Parameter(Mandatory)] [string]$Title
    )
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Output) | Out-Null
    $tmp = "$Output.tmp"
    $lines = @(
        "# $Title",
        "",
        $GeneratedAt,
        ""
    )
    $lines += Get-ComponentSectionLines
    Set-Content -Path $tmp -Value $lines -Encoding UTF8
    Move-Item -Force -Path $tmp -Destination $Output
}

function Write-AgentBundle {
    param(
        [Parameter(Mandatory)] [string]$Output,
        [Parameter(Mandatory)] [string]$Title
    )
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Output) | Out-Null
    $rootAgents = Get-Content (Join-Path $RepoDir "AGENTS.md") | Select-Object -Skip 1
    $tmp = "$Output.tmp"
    $lines = @(
        "# $Title",
        "",
        $GeneratedAt,
        "",
        "## Canonical Global Harness",
        ""
    )
    $lines += $rootAgents
    $lines += @("", "## Component Index", "")
    $lines += Get-ComponentSectionLines
    Set-Content -Path $tmp -Value $lines -Encoding UTF8
    Move-Item -Force -Path $tmp -Destination $Output
}

function Remove-Frontmatter {
    param([Parameter(Mandatory)] [string]$Path)
    $lines = Get-Content $Path
    $inFrontmatter = $false
    $out = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($i -eq 0 -and $lines[$i] -eq "---") {
            $inFrontmatter = $true
            continue
        }
        if ($inFrontmatter -and $lines[$i] -eq "---") {
            $inFrontmatter = $false
            continue
        }
        if (-not $inFrontmatter) {
            $out.Add($lines[$i])
        }
    }
    while ($out.Count -gt 0 -and [string]::IsNullOrWhiteSpace($out[0])) {
        $out.RemoveAt(0)
    }
    return $out
}

Write-ComponentIndex -Output (Join-Path $RepoDir "adapters/claude/COMPONENTS.md") -Title "Claude Component Index"
Write-AgentBundle -Output (Join-Path $RepoDir "adapters/codex/AGENTS.md") -Title "Codex Global Instructions"
Write-AgentBundle -Output (Join-Path $RepoDir "adapters/kimi/AGENTS.md") -Title "Kimi Global Instructions"
Write-AgentBundle -Output (Join-Path $RepoDir "adapters/zcode/AGENTS.md") -Title "ZCode Global Instructions"
Write-AgentBundle -Output (Join-Path $RepoDir "adapters/copilot/instructions/agents-config.generated.md") -Title "Copilot Global Instructions"
Ensure-CatalogAnnotations
$CatalogAnnotations = @{}
Import-Csv -Path $CatalogPt -Delimiter "`t" | ForEach-Object {
    $CatalogAnnotations["$($_.Type)`n$($_.Name)"] = $_
}
Write-Catalog

$copilotProfiles = Join-Path $RepoDir "adapters/copilot/profiles"
New-Item -ItemType Directory -Force -Path $copilotProfiles | Out-Null
Get-ChildItem $copilotProfiles -File -Filter "*.md" | Remove-Item
Get-ChildItem (Join-Path $RepoDir "skills") -Directory | Sort-Object Name | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        Set-Content -Path (Join-Path $copilotProfiles "$($_.Name).md") -Value (Remove-Frontmatter -Path $skillFile) -Encoding UTF8
    }
}

Write-Host "Generated adapters and docs from canonical components."

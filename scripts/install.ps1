$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$KimiCodeHome = if ($env:KIMI_CODE_HOME) { $env:KIMI_CODE_HOME } else { Join-Path $HOME ".kimi-code" }

& (Join-Path $RepoDir "scripts/generate-adapters.ps1")

function Get-PathItem {
    param([Parameter(Mandatory)] [string]$Path)
    return Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
}

function Test-PathOrLink {
    param([Parameter(Mandatory)] [string]$Path)
    return $null -ne (Get-PathItem -Path $Path)
}

function Backup-Path {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [string]$BackupDir = ""
    )
    if ($BackupDir) {
        New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
        $base = Join-Path $BackupDir "$(Split-Path -Leaf $Path).bak"
    } else {
        $base = "$Path.bak"
    }
    $candidate = $base
    $n = 1
    while (Test-PathOrLink -Path $candidate) {
        $candidate = "$base.$n"
        $n += 1
    }
    Rename-Item $Path $candidate
    return $candidate
}

function Set-Link {
    param(
        [Parameter(Mandatory)] [string]$Target,
        [Parameter(Mandatory)] [string]$LinkPath,
        [Parameter(Mandatory)] [ValidateSet("SymbolicLink", "Junction")] [string]$Type,
        [string]$BackupDir = "",
        [string]$BackupMessage = "Existing path moved to backup:"
    )
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $LinkPath) | Out-Null
    $item = Get-PathItem -Path $LinkPath
    if ($item) {
        if ($item.LinkType -and $item.Target -eq $Target) {
            Write-Host "Already linked: $LinkPath -> $Target"
            return
        }
        if ($item.LinkType) {
            if ($item.PSIsContainer) {
                [System.IO.Directory]::Delete($LinkPath, $false)
            } else {
                [System.IO.File]::Delete($LinkPath)
            }
        } else {
            $bak = Backup-Path -Path $LinkPath -BackupDir $BackupDir
            Write-Host "$BackupMessage $bak"
        }
    }
    New-Item -ItemType $Type -Path $LinkPath -Target $Target | Out-Null
    Write-Host "Linked: $LinkPath -> $Target"
}

function Set-CodexSkillLink {
    param(
        [Parameter(Mandatory)] [string]$Target,
        [Parameter(Mandatory)] [string]$LinkPath
    )
    Set-Link `
        -Target $Target `
        -LinkPath $LinkPath `
        -Type Junction `
        -BackupDir (Join-Path $HOME ".codex/skills-backups") `
        -BackupMessage "Existing Codex skill moved to backup:"
}

function Remove-StaleCodexSkillLinks {
    param([Parameter(Mandatory)] [string]$SkillsDir)
    if (-not (Test-Path $SkillsDir -PathType Container)) { return }
    $managedPrefix = (Join-Path $RepoDir "skills") + [System.IO.Path]::DirectorySeparatorChar
    Get-ChildItem $SkillsDir -Force | ForEach-Object {
        if (-not $_.LinkType) { return }
        $target = [string]($_.Target | Select-Object -First 1)
        if ($target.StartsWith($managedPrefix)) {
            if (-not (Test-Path -LiteralPath $target)) {
                Remove-Item -LiteralPath $_.FullName -Force
                Write-Host "Removed stale Codex skill link: $($_.FullName)"
            }
        }
    }
}

$AgentsConfig = Join-Path $HOME ".agents-config"
$item = Get-PathItem -Path $AgentsConfig
if ($item) {
    if ($item.LinkType -and $item.Target -eq $RepoDir) {
        Write-Host "Already linked: $AgentsConfig -> $RepoDir"
    } else {
        if ($item.LinkType) {
            throw "$AgentsConfig already exists and points to '$($item.Target)', not '$RepoDir'. Resolve this manually before running install again."
        }
        throw "$AgentsConfig already exists and is not a link to '$RepoDir'. Resolve this manually before running install again."
    }
} else {
    New-Item -ItemType Junction -Path $AgentsConfig -Target $RepoDir | Out-Null
    Write-Host "Linked: $AgentsConfig -> $RepoDir"
}

$ClaudeDir = Join-Path $HOME ".claude"
Set-Link -Target (Join-Path $RepoDir "CLAUDE.md") -LinkPath (Join-Path $ClaudeDir "CLAUDE.md") -Type SymbolicLink
Set-Link -Target (Join-Path $RepoDir "skills") -LinkPath (Join-Path $ClaudeDir "skills") -Type Junction

$ClaudeSettings = Join-Path $ClaudeDir "settings.json"
if (Test-Path $ClaudeSettings) {
    Write-Host "Notice: $ClaudeSettings exists; not overwritten. Compare with adapters\claude\settings.json for RTK hook."
} else {
    New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
    Copy-Item (Join-Path $RepoDir "adapters/claude/settings.json") $ClaudeSettings
    Write-Host "Copied Claude settings with RTK hook."
}

Set-Link -Target (Join-Path $RepoDir "adapters/codex/AGENTS.md") -LinkPath (Join-Path $HOME ".codex/AGENTS.md") -Type SymbolicLink
$CodexSkills = Join-Path $HOME ".codex/skills"
New-Item -ItemType Directory -Force -Path $CodexSkills | Out-Null
Remove-StaleCodexSkillLinks -SkillsDir $CodexSkills
Get-ChildItem (Join-Path $RepoDir "skills") -Directory | Sort-Object Name | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        Set-CodexSkillLink -Target $_.FullName -LinkPath (Join-Path $CodexSkills $_.Name)
    }
}
Set-Link -Target (Join-Path $RepoDir "adapters/copilot/instructions") -LinkPath (Join-Path $HOME ".copilot/instructions") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/copilot/profiles") -LinkPath (Join-Path $HOME ".copilot/profiles") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/kimi/AGENTS.md") -LinkPath (Join-Path $KimiCodeHome "AGENTS.md") -Type SymbolicLink
Set-Link -Target (Join-Path $RepoDir "skills") -LinkPath (Join-Path $KimiCodeHome "skills") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/zcode/AGENTS.md") -LinkPath (Join-Path $HOME ".zcode/AGENTS.md") -Type SymbolicLink
Set-Link -Target (Join-Path $RepoDir "skills") -LinkPath (Join-Path $HOME ".zcode/skills") -Type Junction

Write-Host "agents-config installed."

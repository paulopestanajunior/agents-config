$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$KimiCodeHome = if ($env:KIMI_CODE_HOME) { $env:KIMI_CODE_HOME } else { Join-Path $HOME ".kimi-code" }

& (Join-Path $RepoDir "scripts/generate-adapters.ps1")

function Backup-Path {
    param([Parameter(Mandatory)] [string]$Path)
    $base = "$Path.bak"
    $candidate = $base
    $n = 1
    while (Test-Path $candidate) {
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
        [Parameter(Mandatory)] [ValidateSet("SymbolicLink", "Junction")] [string]$Type
    )
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $LinkPath) | Out-Null
    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath -Force
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
            $bak = Backup-Path -Path $LinkPath
            Write-Host "Existing path moved to backup: $bak"
        }
    }
    New-Item -ItemType $Type -Path $LinkPath -Target $Target | Out-Null
    Write-Host "Linked: $LinkPath -> $Target"
}

$AgentsConfig = Join-Path $HOME ".agents-config"
if (Test-Path $AgentsConfig) {
    $item = Get-Item $AgentsConfig -Force
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
Set-Link -Target (Join-Path $RepoDir "adapters/copilot/instructions") -LinkPath (Join-Path $HOME ".copilot/instructions") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/copilot/profiles") -LinkPath (Join-Path $HOME ".copilot/profiles") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/kimi/AGENTS.md") -LinkPath (Join-Path $KimiCodeHome "AGENTS.md") -Type SymbolicLink
Set-Link -Target (Join-Path $RepoDir "skills") -LinkPath (Join-Path $KimiCodeHome "skills") -Type Junction
Set-Link -Target (Join-Path $RepoDir "adapters/zcode/AGENTS.md") -LinkPath (Join-Path $HOME ".zcode/AGENTS.md") -Type SymbolicLink
Set-Link -Target (Join-Path $RepoDir "skills") -LinkPath (Join-Path $HOME ".zcode/skills") -Type Junction

Write-Host "agents-config installed."

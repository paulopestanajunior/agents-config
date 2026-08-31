param(
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not (Test-Path $Target -PathType Container)) {
    throw "Target directory not found: $Target"
}

function Say {
    param([Parameter(Mandatory)] [string]$Message)
    if ($DryRun) {
        Write-Host "[dry-run] $Message"
    } else {
        Write-Host $Message
    }
}

function Ensure-Dir {
    param([Parameter(Mandatory)] [string]$RelativePath)
    $dir = Join-Path $Target $RelativePath
    if (Test-Path $dir -PathType Container) {
        Say "exists: $dir"
    } else {
        Say "create directory: $dir"
        if (-not $DryRun) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }
    }
}

function Ensure-FileFromTemplate {
    param(
        [Parameter(Mandatory)] [string]$RelativePath,
        [Parameter(Mandatory)] [string]$TemplateName
    )
    $dest = Join-Path $Target $RelativePath
    if (Test-Path $dest) {
        Say "exists, not overwritten: $dest"
    } else {
        Say "create file: $dest"
        if (-not $DryRun) {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
            Copy-Item (Join-Path $RepoDir "templates/$TemplateName") $dest
        }
    }
}

Ensure-FileFromTemplate -RelativePath "AGENTS.md" -TemplateName "AGENTS.md"
Ensure-FileFromTemplate -RelativePath "PROJECT.md" -TemplateName "PROJECT.md"
Ensure-FileFromTemplate -RelativePath "ARCHITECTURE.md" -TemplateName "ARCHITECTURE.md"
Ensure-FileFromTemplate -RelativePath "WORKING_CONTEXT.md" -TemplateName "WORKING_CONTEXT.md"
Ensure-Dir -RelativePath "docs/decisions"
Ensure-Dir -RelativePath "docs/plans/active"
Ensure-Dir -RelativePath "docs/plans/completed"
Ensure-Dir -RelativePath "docs/specs/active"
Ensure-Dir -RelativePath "docs/specs/completed"
Ensure-Dir -RelativePath ".agents/overrides"

Write-Host @'

Next step: the files above are templates. Fill them with one of:

  workflow: project-kickoff       new project from an idea or briefing
  workflow: codebase-onboarding   existing repository you have not worked in

Example prompt:

  Use:
  role: tech-lead
  workflow: project-kickoff
  profile: deep

  <your briefing here>
'@

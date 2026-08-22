$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $RepoDir "scripts/install.ps1") @args

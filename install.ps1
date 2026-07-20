$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $HOME ".claude"

New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

$SkillsTarget = Join-Path $ClaudeDir "skills"
if ((Test-Path $SkillsTarget) -and -not (Get-Item $SkillsTarget).LinkType) {
    Write-Host "Aviso: $SkillsTarget já existe e não é um link. Renomeando para skills.bak"
    Rename-Item $SkillsTarget "skills.bak"
}
if (Test-Path $SkillsTarget) { Remove-Item $SkillsTarget -Force }
New-Item -ItemType Junction -Path $SkillsTarget -Target (Join-Path $RepoDir "skills") | Out-Null
Write-Host "Link criado: $SkillsTarget -> $RepoDir\skills"

$ClaudeMdTarget = Join-Path $ClaudeDir "CLAUDE.md"
if ((Test-Path $ClaudeMdTarget) -and -not (Get-Item $ClaudeMdTarget).LinkType) {
    Write-Host "Aviso: $ClaudeMdTarget já existe e não é um link. Renomeando para CLAUDE.md.bak"
    Rename-Item $ClaudeMdTarget "CLAUDE.md.bak"
}
if (Test-Path $ClaudeMdTarget) { Remove-Item $ClaudeMdTarget -Force }
New-Item -ItemType SymbolicLink -Path $ClaudeMdTarget -Target (Join-Path $RepoDir "CLAUDE.md") | Out-Null
Write-Host "Link criado: $ClaudeMdTarget -> $RepoDir\CLAUDE.md"

$SettingsTarget = Join-Path $ClaudeDir "settings.json"
if (Test-Path $SettingsTarget) {
    Write-Host "Aviso: $SettingsTarget já existe. Não sobrescrito automaticamente."
    Write-Host "Compare manualmente com $RepoDir\settings.json e faça merge (ex.: hook do rtk)."
} else {
    Copy-Item (Join-Path $RepoDir "settings.json") $SettingsTarget
    Write-Host "settings.json copiado para $SettingsTarget"
}

Write-Host ""
Write-Host "Falta reinstalar o RTK (não versionado neste repo):"
Write-Host "  Baixe rtk-x86_64-pc-windows-msvc.zip em github.com/rtk-ai/rtk/releases,"
Write-Host "  extraia rtk.exe e adicione ao PATH (ex.: C:\Users\<voce>\.local\bin)."
Write-Host "  Depois rode: rtk init -g"
Write-Host ""
Write-Host "Nota: New-Item -ItemType SymbolicLink e Junction podem exigir PowerShell como Administrador,"
Write-Host "ou o Developer Mode ativado em Configuracoes > Privacidade e Seguranca > Para Desenvolvedores."

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $HOME ".claude"

New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

# Cria (ou substitui) um link, cuidando pra não perder um arquivo/pasta real
# que já existisse no lugar (renomeia pra .bak em vez de apagar).
# Usa .NET Directory/File.Delete em vez de Remove-Item pra remover um link
# antigo: Remove-Item numa junction/reparse point dispara um prompt interno
# do PowerShell 5.1 que quebra em sessão não-interativa, mesmo com -Force.
function Set-Link {
    param(
        [Parameter(Mandatory)] [string]$LinkPath,
        [Parameter(Mandatory)] [string]$Target,
        [Parameter(Mandatory)] [ValidateSet("SymbolicLink", "Junction")] [string]$Type
    )

    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath -Force
        if (-not $item.LinkType) {
            $bakName = (Split-Path -Leaf $LinkPath) + ".bak"
            Write-Host "Aviso: $LinkPath já existe e não é um link. Renomeando para $bakName"
            Rename-Item $LinkPath $bakName
        } elseif ($item.Target -eq $Target) {
            Write-Host "Já correto: $LinkPath -> $Target"
            return
        } else {
            if ($item.PSIsContainer) {
                [System.IO.Directory]::Delete($LinkPath, $false)
            } else {
                [System.IO.File]::Delete($LinkPath)
            }
        }
    }

    if (-not (Test-Path $LinkPath)) {
        New-Item -ItemType $Type -Path $LinkPath -Target $Target | Out-Null
        Write-Host "Link criado: $LinkPath -> $Target"
    }
}

Set-Link -LinkPath (Join-Path $ClaudeDir "skills") -Target (Join-Path $RepoDir "skills") -Type Junction
Set-Link -LinkPath (Join-Path $ClaudeDir "CLAUDE.md") -Target (Join-Path $RepoDir "CLAUDE.md") -Type SymbolicLink

$SettingsTarget = Join-Path $ClaudeDir "settings.json"
if (Test-Path $SettingsTarget) {
    Write-Host "Aviso: $SettingsTarget já existe. Não sobrescrito automaticamente."
    Write-Host "Compare manualmente com $RepoDir\settings.json e faça merge (ex.: hook do rtk)."
} else {
    Copy-Item (Join-Path $RepoDir "settings.json") $SettingsTarget
    Write-Host "settings.json copiado para $SettingsTarget"
}

# Codex CLI: ~/.codex/AGENTS.md é global e concatenado automaticamente com
# o AGENTS.md de cada projeto -- não precisa de deploy-to-project.ps1.
$CodexDir = Join-Path $HOME ".codex"
New-Item -ItemType Directory -Force -Path $CodexDir | Out-Null
Set-Link -LinkPath (Join-Path $CodexDir "AGENTS.md") -Target (Join-Path $RepoDir "portable\AGENTS.global.md") -Type SymbolicLink
Set-Link -LinkPath (Join-Path $CodexDir "profiles") -Target (Join-Path $RepoDir "portable\profiles") -Type Junction

# GitHub Copilot (VS Code): ~/.copilot/instructions é lido em toda sessão,
# em qualquer workspace, sem precisar de .github/copilot-instructions.md
# por projeto. Recurso mais novo -- confira no VS Code se sua versão já lê
# instruções de usuário desta pasta.
$CopilotDir = Join-Path $HOME ".copilot"
New-Item -ItemType Directory -Force -Path $CopilotDir | Out-Null
Set-Link -LinkPath (Join-Path $CopilotDir "instructions") -Target (Join-Path $RepoDir "portable\copilot-instructions") -Type Junction
Set-Link -LinkPath (Join-Path $CopilotDir "profiles") -Target (Join-Path $RepoDir "portable\profiles") -Type Junction

Write-Host ""
Write-Host "Falta reinstalar o RTK (não versionado neste repo):"
Write-Host "  Baixe rtk-x86_64-pc-windows-msvc.zip em github.com/rtk-ai/rtk/releases,"
Write-Host "  extraia rtk.exe e adicione ao PATH (ex.: C:\Users\<voce>\.local\bin)."
Write-Host "  Depois rode: rtk init -g"
Write-Host ""
Write-Host "Nota: New-Item -ItemType SymbolicLink e Junction podem exigir PowerShell como Administrador,"
Write-Host "ou o Developer Mode ativado em Configuracoes > Privacidade e Seguranca > Para Desenvolvedores."

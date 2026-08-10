#!/bin/sh
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

if [ -e "$CLAUDE_DIR/skills" ] && [ ! -L "$CLAUDE_DIR/skills" ]; then
  echo "Aviso: $CLAUDE_DIR/skills já existe e não é um symlink. Renomeando para skills.bak"
  mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.bak"
fi
ln -sfn "$REPO_DIR/skills" "$CLAUDE_DIR/skills"
echo "Symlink criado: $CLAUDE_DIR/skills -> $REPO_DIR/skills"

if [ -e "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "Aviso: $CLAUDE_DIR/CLAUDE.md já existe e não é um symlink. Renomeando para CLAUDE.md.bak"
  mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
fi
ln -sfn "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "Symlink criado: $CLAUDE_DIR/CLAUDE.md -> $REPO_DIR/CLAUDE.md"

if [ -e "$CLAUDE_DIR/settings.json" ]; then
  echo "Aviso: $CLAUDE_DIR/settings.json já existe. Não sobrescrito automaticamente."
  echo "Compare manualmente com $REPO_DIR/settings.json e faça merge (ex.: hook do rtk)."
else
  cp "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "settings.json copiado para $CLAUDE_DIR/settings.json"
fi

# Codex CLI: ~/.codex/AGENTS.md é global e concatenado automaticamente com
# o AGENTS.md de cada projeto — não precisa de deploy-to-project.sh.
CODEX_DIR="$HOME/.codex"
mkdir -p "$CODEX_DIR"

if [ -e "$CODEX_DIR/AGENTS.md" ] && [ ! -L "$CODEX_DIR/AGENTS.md" ]; then
  echo "Aviso: $CODEX_DIR/AGENTS.md já existe e não é um symlink. Renomeando para AGENTS.md.bak"
  mv "$CODEX_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md.bak"
fi
ln -sfn "$REPO_DIR/portable/AGENTS.global.md" "$CODEX_DIR/AGENTS.md"
echo "Symlink criado: $CODEX_DIR/AGENTS.md -> $REPO_DIR/portable/AGENTS.global.md"

if [ -e "$CODEX_DIR/profiles" ] && [ ! -L "$CODEX_DIR/profiles" ]; then
  echo "Aviso: $CODEX_DIR/profiles já existe e não é um symlink. Renomeando para profiles.bak"
  mv "$CODEX_DIR/profiles" "$CODEX_DIR/profiles.bak"
fi
ln -sfn "$REPO_DIR/portable/profiles" "$CODEX_DIR/profiles"
echo "Symlink criado: $CODEX_DIR/profiles -> $REPO_DIR/portable/profiles"

# GitHub Copilot (VS Code): ~/.copilot/instructions é lido em toda sessão,
# em qualquer workspace, sem precisar de .github/copilot-instructions.md
# por projeto. Recurso mais novo — confira no VS Code se sua versão já lê
# instruções de usuário desta pasta.
COPILOT_DIR="$HOME/.copilot"
mkdir -p "$COPILOT_DIR"

if [ -e "$COPILOT_DIR/instructions" ] && [ ! -L "$COPILOT_DIR/instructions" ]; then
  echo "Aviso: $COPILOT_DIR/instructions já existe e não é um symlink. Renomeando para instructions.bak"
  mv "$COPILOT_DIR/instructions" "$COPILOT_DIR/instructions.bak"
fi
ln -sfn "$REPO_DIR/portable/copilot-instructions" "$COPILOT_DIR/instructions"
echo "Symlink criado: $COPILOT_DIR/instructions -> $REPO_DIR/portable/copilot-instructions"

if [ -e "$COPILOT_DIR/profiles" ] && [ ! -L "$COPILOT_DIR/profiles" ]; then
  echo "Aviso: $COPILOT_DIR/profiles já existe e não é um symlink. Renomeando para profiles.bak"
  mv "$COPILOT_DIR/profiles" "$COPILOT_DIR/profiles.bak"
fi
ln -sfn "$REPO_DIR/portable/profiles" "$COPILOT_DIR/profiles"
echo "Symlink criado: $COPILOT_DIR/profiles -> $REPO_DIR/portable/profiles"

echo ""
echo "Falta reinstalar o RTK (não versionado neste repo):"
echo "  brew install rtk && rtk init -g"

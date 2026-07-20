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

echo ""
echo "Falta reinstalar o RTK (não versionado neste repo):"
echo "  brew install rtk && rtk init -g"

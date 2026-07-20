#!/bin/sh
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

rsync -a --delete "$CLAUDE_DIR/skills/" "$REPO_DIR/skills/"
cp "$CLAUDE_DIR/CLAUDE.md" "$REPO_DIR/CLAUDE.md"
cp "$CLAUDE_DIR/settings.json" "$REPO_DIR/settings.json"

echo "Sincronizado de $CLAUDE_DIR para $REPO_DIR."
echo "Revise 'git status' e commite."

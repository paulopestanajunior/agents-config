#!/bin/sh
set -eu

if [ "${1:-}" != "--confirm" ]; then
  echo "This legacy Claude sync can overwrite harness files from ~/.claude."
  echo "Run only if you intentionally edited ~/.claude directly:"
  echo "  adapters/claude/sync-from-claude.sh --confirm"
  exit 2
fi

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

if [ -L "$CLAUDE_DIR/skills" ] || [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "$CLAUDE_DIR is already linked to this harness; nothing to sync." >&2
  echo "Edit the repository files directly, then run scripts/generate-adapters.sh." >&2
  exit 0
fi

rsync -a --delete "$CLAUDE_DIR/skills/" "$REPO_DIR/skills/"
cp "$CLAUDE_DIR/CLAUDE.md" "$REPO_DIR/CLAUDE.md"
cp "$CLAUDE_DIR/settings.json" "$REPO_DIR/adapters/claude/settings.json"

echo "Synced from $CLAUDE_DIR. Review git status before committing."

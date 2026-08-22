#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
KIMI_CODE_HOME="${KIMI_CODE_HOME:-$HOME/.kimi-code}"

"$REPO_DIR/scripts/generate-adapters.sh"

backup_path() {
  path="$1"
  base="$path.bak"
  candidate="$base"
  n=1
  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="$base.$n"
    n=$((n + 1))
  done
  mv "$path" "$candidate"
  echo "$candidate"
}

safe_link() {
  target="$1"
  link="$2"
  mkdir -p "$(dirname "$link")"
  if [ -L "$link" ]; then
    current="$(readlink "$link")"
    if [ "$current" = "$target" ]; then
      echo "Already linked: $link -> $target"
      return
    fi
    rm "$link"
  elif [ -e "$link" ]; then
    bak="$(backup_path "$link")"
    echo "Existing path moved to backup: $bak"
  fi
  ln -s "$target" "$link"
  echo "Linked: $link -> $target"
}

backup_codex_skill_path() {
  path="$1"
  backup_dir="$HOME/.codex/skills-backups"
  mkdir -p "$backup_dir"
  name="$(basename "$path")"
  base="$backup_dir/$name.bak"
  candidate="$base"
  n=1
  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="$base.$n"
    n=$((n + 1))
  done
  mv "$path" "$candidate"
  echo "$candidate"
}

safe_codex_skill_link() {
  target="$1"
  link="$2"
  mkdir -p "$(dirname "$link")"
  if [ -L "$link" ]; then
    current="$(readlink "$link")"
    if [ "$current" = "$target" ]; then
      echo "Already linked: $link -> $target"
      return
    fi
    rm "$link"
  elif [ -e "$link" ]; then
    bak="$(backup_codex_skill_path "$link")"
    echo "Existing Codex skill moved to backup: $bak"
  fi
  ln -s "$target" "$link"
  echo "Linked: $link -> $target"
}

if [ -e "$HOME/.agents-config" ] || [ -L "$HOME/.agents-config" ]; then
  if [ -L "$HOME/.agents-config" ] && [ "$(readlink "$HOME/.agents-config")" = "$REPO_DIR" ]; then
    echo "Already linked: $HOME/.agents-config -> $REPO_DIR"
  else
    echo "Error: $HOME/.agents-config already exists and does not point to this checkout." >&2
    if [ -L "$HOME/.agents-config" ]; then
      echo "Current target: $(readlink "$HOME/.agents-config")" >&2
    else
      echo "Current path is not a symlink." >&2
    fi
    echo "Expected target: $REPO_DIR" >&2
    echo "Resolve this manually before running install again." >&2
    exit 1
  fi
else
  ln -s "$REPO_DIR" "$HOME/.agents-config"
  echo "Linked: $HOME/.agents-config -> $REPO_DIR"
fi

safe_link "$REPO_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
safe_link "$REPO_DIR/skills" "$HOME/.claude/skills"

if [ -f "$HOME/.claude/settings.json" ]; then
  echo "Notice: $HOME/.claude/settings.json exists; not overwritten. Compare with adapters/claude/settings.json for RTK hook."
else
  mkdir -p "$HOME/.claude"
  cp "$REPO_DIR/adapters/claude/settings.json" "$HOME/.claude/settings.json"
  echo "Copied Claude settings with RTK hook."
fi

safe_link "$REPO_DIR/adapters/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
mkdir -p "$HOME/.codex/skills"
for skill_file in "$REPO_DIR"/skills/*/SKILL.md; do
  [ -f "$skill_file" ] || continue
  skill_name="$(basename "$(dirname "$skill_file")")"
  safe_codex_skill_link "$REPO_DIR/skills/$skill_name" "$HOME/.codex/skills/$skill_name"
done
safe_link "$REPO_DIR/adapters/copilot/instructions" "$HOME/.copilot/instructions"
safe_link "$REPO_DIR/adapters/copilot/profiles" "$HOME/.copilot/profiles"
safe_link "$REPO_DIR/adapters/kimi/AGENTS.md" "$KIMI_CODE_HOME/AGENTS.md"
safe_link "$REPO_DIR/skills" "$KIMI_CODE_HOME/skills"
safe_link "$REPO_DIR/adapters/zcode/AGENTS.md" "$HOME/.zcode/AGENTS.md"
safe_link "$REPO_DIR/skills" "$HOME/.zcode/skills"

echo "agents-config installed."

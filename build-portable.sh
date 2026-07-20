#!/bin/sh
# Gera portable/profiles/*.md a partir de skills/*/SKILL.md, removendo o
# frontmatter YAML (exclusivo do Claude Code) e mantendo só o corpo em
# Markdown puro, legível por Codex, Copilot ou qualquer outra ferramenta.
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
OUT_DIR="$REPO_DIR/portable/profiles"

mkdir -p "$OUT_DIR"

for skill_dir in "$SKILLS_DIR"/*/; do
  name="$(basename "$skill_dir")"
  src="$skill_dir/SKILL.md"
  [ -f "$src" ] || continue
  dest="$OUT_DIR/$name.md"

  awk '
    BEGIN { infm = 0; seen = 0 }
    /^---$/ { infm = !infm; seen = 1; next }
    seen && !infm { print }
    !seen { print }
  ' "$src" | sed '/./,$!d' > "$dest"

  echo "Gerado: $dest"
done

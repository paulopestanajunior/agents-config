#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TARGET=""
DRY_RUN=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      shift
      [ "$#" -gt 0 ] || { echo "--target requires a path" >&2; exit 2; }
      TARGET="$1"
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: scripts/init-project.sh --target /path/to/project [--dry-run]" >&2
      exit 2
      ;;
  esac
  shift
done

[ -n "$TARGET" ] || { echo "Usage: scripts/init-project.sh --target /path/to/project [--dry-run]" >&2; exit 2; }
[ -d "$TARGET" ] || { echo "Target directory not found: $TARGET" >&2; exit 1; }

say() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$1"
  else
    printf '%s\n' "$1"
  fi
}

ensure_dir() {
  dir="$TARGET/$1"
  if [ -d "$dir" ]; then
    say "exists: $dir"
  else
    say "create directory: $dir"
    [ "$DRY_RUN" -eq 1 ] || mkdir -p "$dir"
  fi
}

ensure_file_from_template() {
  rel="$1"
  template="$2"
  dest="$TARGET/$rel"
  if [ -e "$dest" ]; then
    say "exists, not overwritten: $dest"
  else
    say "create file: $dest"
    if [ "$DRY_RUN" -ne 1 ]; then
      mkdir -p "$(dirname "$dest")"
      cp "$REPO_DIR/templates/$template" "$dest"
    fi
  fi
}

ensure_file_from_template "AGENTS.md" "AGENTS.md"
ensure_file_from_template "PROJECT.md" "PROJECT.md"
ensure_file_from_template "ARCHITECTURE.md" "ARCHITECTURE.md"
ensure_dir "docs/decisions"
ensure_dir "docs/plans/active"
ensure_dir "docs/plans/completed"
ensure_dir "docs/specs/active"
ensure_dir "docs/specs/completed"
ensure_dir ".agents/overrides"

#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
exec "$REPO_DIR/adapters/claude/sync-from-claude.sh" "$@"

#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [ "$#" -eq 1 ]; then
  exec "$REPO_DIR/scripts/init-project.sh" --target "$1"
fi
exec "$REPO_DIR/scripts/init-project.sh" "$@"

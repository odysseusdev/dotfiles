#!/usr/bin/env bash

# Bootstraps the Python venv if needed, then delegates to .sync/sync.py.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_DIR="$SCRIPT_DIR/.sync"
VENV_DIR="$SYNC_DIR/.venv"
REQUIREMENTS="$SYNC_DIR/requirements.txt"

banner "zsa sync"

if ! command -v python3 &>/dev/null; then
  abort "python3 is required"
fi

# Bootstrap venv on first run or if dependencies are missing.
if [[ ! -f "$VENV_DIR/bin/python" ]] || ! "$VENV_DIR/bin/python" -c "import requests, yaml, keymap_drawer" 2>/dev/null; then
  section "bootstrapping environment"
  printf "    %shanding off to pip...%s\n\n" "$DIM" "$RESET"
  python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/pip" install -r "$REQUIREMENTS" --quiet
  printf "\n    %s✓%s  dependencies installed\n" "$GREEN" "$RESET"
fi

"$VENV_DIR/bin/python" "$SYNC_DIR/sync.py" "$@"

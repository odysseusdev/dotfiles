#!/usr/bin/env bash

# Bootstraps the Python venv if needed, then delegates to .sync/sync.py.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_DIR="$SCRIPT_DIR/.sync"
VENV_DIR="$SYNC_DIR/.venv"
REQUIREMENTS="$SYNC_DIR/requirements.txt"

# Catppuccin Macchiato
MAUVE=$'\033[38;2;198;160;246m'
GREEN=$'\033[38;2;166;218;149m'
RED=$'\033[38;2;237;135;150m'
DIM=$'\033[38;2;128;135;162m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

section() {
  printf "\n  %s%s%s%s\n\n" "$MAUVE" "$BOLD" "$1" "$RESET"
}

abort() {
  printf "\n  %s%s✗  %s%s\n\n" "$RED" "$BOLD" "$1" "$RESET"
  exit 1
}

printf "\n  %s%sdotfiles%s  %s/ zsa sync%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$RESET"

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

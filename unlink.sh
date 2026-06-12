#!/usr/bin/env bash

# Remove all symlinks created by link.sh.
set -euo pipefail

# Resolve the dotfiles directory regardless of where the script is called from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Catppuccin Macchiato
MAUVE=$'\033[38;2;198;160;246m'
GREEN=$'\033[38;2;166;218;149m'
RED=$'\033[38;2;237;135;150m'
TEAL=$'\033[38;2;139;213;202m'
DIM=$'\033[38;2;128;135;162m'
TEXT=$'\033[38;2;202;211;245m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

section() {
  printf "\n  %s%s%s%s\n\n" "$MAUVE" "$BOLD" "$1" "$RESET"
}

# Remove stowed symlinks from target. Mirrors stow_packages in link.sh.
# Entries can be "package" or "package:label" to display a different name.
unstow_packages() {
  local stow_directory="$1" target="$2"; shift 2
  for entry in "$@"; do
    local package="${entry%%:*}"  # package name (before the colon, or the full entry)
    local label="${entry#*:}"     # display label (after the colon, or same as package)
    stow --dir="$stow_directory" --target="$target" --delete --no-folding "$package"
    printf "    %s✗%s  %s%-14s%s  %s→  %s%s\n" \
      "$RED" "$RESET" \
      "$TEXT" "$label" "$RESET" \
      "$DIM" "$TEAL" "${target/#$HOME/~}$RESET"
  done
}

printf "\n  %s%sdotfiles%s  %s/ unlink%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$RESET"

section "packages"
unstow_packages "$DOTFILES" "$HOME" assets ghostty git zsh vscode

# macOS stores some app configs outside ~/.config; handle them separately.
if [[ "$(uname -s)" == "Darwin" ]]; then
  section "macos extras"
  VSCODE_TARGET="$HOME/Library/Application Support/Code/User"
  unstow_packages "$DOTFILES/vscode/.config/Code" "$VSCODE_TARGET" "User:vscode"
fi

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

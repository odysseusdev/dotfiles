#!/usr/bin/env bash

# Remove all symlinks created by link.sh.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Remove stowed symlinks from target. Mirrors stow_packages in link.sh.
# Entries can be "package" or "package:label" to display a different name.
unstow_packages() {
  local stow_directory="$1" target="$2"; shift 2
  for entry in "$@"; do
    local package="${entry%%:*}"  # package name (before the colon, or the full entry)
    local label="${entry#*:}"     # display label (after the colon, or same as package)
    stow --dir="$stow_directory" --target="$target" --delete --no-folding "$package"
    printf "    %s✗%s  %s%-14s%s  %s→  %s%s%s\n" \
      "$RED" "$RESET" \
      "$TEXT" "$label" "$RESET" \
      "$DIM" "$TEAL" "${target/#$HOME/~}" "$RESET"
  done
}

banner "unlink"

section "packages"
unstow_packages "$DOTFILES" "$HOME" fastfetch ghostty git hypr nvim tmux vscode wireplumber zsh

# macOS stores some app configs outside ~/.config; handle them separately.
if [[ "$(uname -s)" == "Darwin" ]]; then
  section "macos extras"
  VSCODE_TARGET="$HOME/Library/Application Support/Code/User"
  unstow_packages "$DOTFILES/vscode/.config/Code" "$VSCODE_TARGET" "User:vscode"
fi

section "zen"
if ZEN_PROFILE="$(find_zen_profile)"; then
  unstow_packages "$DOTFILES" "$ZEN_PROFILE" zen
fi

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

#!/usr/bin/env bash

# Stow all dotfile packages into ~ and apply any platform-specific extras.
set -euo pipefail

# Resolve the dotfiles directory regardless of where the script is called from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Catppuccin Macchiato
MAUVE=$'\033[38;2;198;160;246m'
GREEN=$'\033[38;2;166;218;149m'
TEAL=$'\033[38;2;139;213;202m'
DIM=$'\033[38;2;128;135;162m'
TEXT=$'\033[38;2;202;211;245m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

section() {
  printf "\n  %s%s%s%s\n\n" "$MAUVE" "$BOLD" "$1" "$RESET"
}

# Stow packages from stow_directory into target.
# Entries can be "package" or "package:label" to display a different name (e.g. "User:vscode").
# Real files that would conflict with stow are removed beforehand.
stow_packages() {
  local stow_directory="$1" target="$2"; shift 2
  for entry in "$@"; do
    local package="${entry%%:*}"  # package name (before the colon, or the full entry)
    local label="${entry#*:}"     # display label (after the colon, or same as package)

    # Stow refuses to overwrite real files — remove any that would conflict.
    while IFS= read -r -d '' source_file; do
      local relative_path="${source_file#$stow_directory/$package/}"
      local destination="$target/$relative_path"
      if [[ -e "$destination" && ! -L "$destination" ]]; then
        rm "$destination"
      fi
    done < <(find "$stow_directory/$package" -type f -print0)

    stow --dir="$stow_directory" --target="$target" --restow --no-folding "$package"
    printf "    %s✓%s  %s%-14s%s  %s→  %s%s\n" \
      "$GREEN" "$RESET" \
      "$TEXT" "$label" "$RESET" \
      "$DIM" "$TEAL" "${target/#$HOME/~}$RESET"
  done
}

printf "\n  %s%sdotfiles%s  %s/ link%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$RESET"

section "packages"
stow_packages "$DOTFILES" "$HOME" assets ghostty git zsh vscode

# macOS stores some app configs outside ~/.config — handle them separately.
if [[ "$(uname -s)" == "Darwin" ]]; then
  section "macos extras"
  VSCODE_TARGET="$HOME/Library/Application Support/Code/User"
  mkdir -p "$VSCODE_TARGET"
  stow_packages "$DOTFILES/vscode/.config/Code" "$VSCODE_TARGET" "User:vscode"
fi

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

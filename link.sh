#!/usr/bin/env bash

# Stow all dotfile packages into ~ and apply any platform-specific extras.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Stow packages from stow_directory into target.
# Entries can be "package" or "package:label" to display a different name (e.g. "User:vscode").
# Real files that would conflict with stow are logged and removed beforehand.
stow_packages() {
  local stow_directory="$1" target="$2"; shift 2
  for entry in "$@"; do
    local package="${entry%%:*}"  # package name (before the colon, or the full entry)
    local label="${entry#*:}"     # display label (after the colon, or same as package)

    # Stow refuses to overwrite real files; collect and remove any that would conflict.
    local -a conflicts=()
    while IFS= read -r -d '' source_file; do
      local relative_path="${source_file#$stow_directory/$package/}"
      local destination="$target/$relative_path"
      if [[ -e "$destination" && ! -L "$destination" ]]; then
        conflicts+=("$destination")
      fi
    done < <(find "$stow_directory/$package" -type f -print0)

    if [[ ${#conflicts[@]} -gt 0 ]]; then
      printf "    %s!%s  removing conflicts\n" "$MAUVE" "$RESET"
      rm "${conflicts[@]}"
    fi

    stow --dir="$stow_directory" --target="$target" --restow --no-folding "$package"
    printf "    %s✓%s  %s%-14s%s  %s→  %s%s%s\n" \
      "$GREEN" "$RESET" \
      "$TEXT" "$label" "$RESET" \
      "$DIM" "$TEAL" "${target/#$HOME/~}" "$RESET"
  done
}

banner "link"

section "packages"
stow_packages "$DOTFILES" "$HOME" fastfetch ghostty git hypr nvim tmux vscode wireplumber zsh

# macOS stores some app configs outside ~/.config; handle them separately.
if [[ "$(uname -s)" == "Darwin" ]]; then
  section "macos extras"
  VSCODE_TARGET="$HOME/Library/Application Support/Code/User"
  mkdir -p "$VSCODE_TARGET"
  stow_packages "$DOTFILES/vscode/.config/Code" "$VSCODE_TARGET" "User:vscode"
fi

section "zen"
if ZEN_PROFILE="$(find_zen_profile)"; then
  mkdir -p "$ZEN_PROFILE/chrome"
  stow_packages "$DOTFILES" "$ZEN_PROFILE" zen
fi

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

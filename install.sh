#!/usr/bin/env bash

# Install packages for the current platform. Run this before link.sh.
set -euo pipefail

# Resolve the dotfiles directory regardless of where the script is called from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Terminate with a clear message if a required command is not available.
require() {
  local required_command="$1" message="$2"
  if ! command -v "$required_command" &>/dev/null; then
    abort "$message"
  fi
}

# Read package names from a file, skipping comments and blank lines.
read_packages() {
  local file_path="$1"
  grep -v '^\s*#' "$file_path" | grep -v '^\s*$'
}

printf "\n  %s%sdotfiles%s  %s/ install%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$RESET"

case "$(uname -s)" in
  Darwin)
    require brew "homebrew is not installed — visit https://brew.sh"

    section "updating homebrew"
    brew update

    section "homebrew"
    brew bundle --file="$DOTFILES/brew/Brewfile"
    ;;

  Linux)
    require pacman "pacman is not installed"
    require yay "yay is not installed — install it from the AUR before running this script"

    # Sync package databases and upgrade the system before installing anything.
    section "updating system"
    sudo pacman -Syu

    section "pacman"
    mapfile -t pacman_packages < <(read_packages "$DOTFILES/pacman/pacman")
    sudo pacman -S --needed "${pacman_packages[@]}"

    section "aur"
    mapfile -t aur_packages < <(read_packages "$DOTFILES/pacman/aur")
    yay -S --needed "${aur_packages[@]}"
    ;;

  *)
    abort "unsupported operating system: $(uname -s)"
    ;;
esac

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

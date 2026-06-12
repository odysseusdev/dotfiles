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

# Locate the VSCode CLI binary using known install paths for the current platform.
find_vscode_binary() {
  local -a candidate_paths
  case "$(uname -s)" in
    Darwin) candidate_paths=("/opt/homebrew/bin/code" "/usr/local/bin/code") ;;
    Linux)  candidate_paths=("/usr/bin/code") ;;
  esac
  for candidate_path in "${candidate_paths[@]}"; do
    if [[ -x "$candidate_path" ]]; then
      echo "$candidate_path"
      return
    fi
  done
}

printf "\n  %s%sdotfiles%s  %s/ install%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$RESET"

# Ask upfront so the install runs without interruption.
printf "\n  sync vscode extensions after install? %s[y/N]%s " "$DIM" "$RESET"
read -r install_extensions_choice

if [[ "$install_extensions_choice" =~ ^[Yy]$ ]]; then
  # Wipes everything not in the list — good for a clean slate, optional otherwise.
  printf "  clear existing extensions first? %s[y/N]%s " "$DIM" "$RESET"
  read -r clear_extensions_choice
fi

case "$(uname -s)" in
  Darwin)
    require brew "homebrew is not installed — visit https://brew.sh"

    section "updating homebrew"
    printf "  %shanding off to homebrew...%s\n\n" "$DIM" "$RESET"
    brew update
    printf "\n  %s✓%s  homebrew updated\n" "$GREEN" "$RESET"

    section "installing homebrew packages"
    printf "  %shanding off to homebrew...%s\n\n" "$DIM" "$RESET"
    brew bundle --file="$DOTFILES/brew/Brewfile"
    printf "\n  %s✓%s  homebrew packages installed\n" "$GREEN" "$RESET"
    ;;

  Linux)
    require pacman "pacman is not installed"
    require yay "yay is not installed — install it from the AUR before running this script"

    # yay -Syu covers both pacman and AUR — no need for a separate pacman refresh.
    section "updating system"
    printf "  %shanding off to yay...%s\n\n" "$DIM" "$RESET"
    yay -Syu
    printf "\n  %s✓%s  system updated\n" "$GREEN" "$RESET"

    section "installing pacman packages"
    printf "  %shanding off to pacman...%s\n\n" "$DIM" "$RESET"
    mapfile -t pacman_packages < <(read_packages "$DOTFILES/pacman/pacman")
    sudo pacman -S --needed "${pacman_packages[@]}"
    printf "\n  %s✓%s  pacman packages installed\n" "$GREEN" "$RESET"

    section "installing aur packages"
    printf "  %shanding off to yay...%s\n\n" "$DIM" "$RESET"
    mapfile -t aur_packages < <(read_packages "$DOTFILES/pacman/aur")
    yay -S --needed "${aur_packages[@]}"
    printf "\n  %s✓%s  aur packages installed\n" "$GREEN" "$RESET"
    ;;

  *)
    abort "unsupported operating system: $(uname -s)"
    ;;
esac

if [[ ! "$install_extensions_choice" =~ ^[Yy]$ ]]; then
  printf "\n  %sskipping vscode extensions%s\n" "$DIM" "$RESET"
else
  section "vscode extensions"

  # Use the full path — PATH won't include a brand new VSCode install yet.
  vscode_binary="$(find_vscode_binary)"

  if [[ -z "$vscode_binary" ]]; then
    # Probably a fresh install — open a new terminal to pick up the binary.
    printf "  %s✗%s  vscode binary not found — open a new terminal and re-run to install extensions\n" "$RED" "$RESET"
  else
    if [[ "${clear_extensions_choice:-}" =~ ^[Yy]$ ]]; then
      # Deletes ~/.vscode/extensions — VSCode recreates it on next launch.
      rm -rf "$HOME/.vscode/extensions"
    fi

    while IFS= read -r extension_id; do
      if "$vscode_binary" --install-extension "$extension_id" --force &>/dev/null; then
        printf "    %s✓%s  %s\n" "$GREEN" "$RESET" "$extension_id"
      else
        printf "    %s✗%s  %s\n" "$RED" "$RESET" "$extension_id"
      fi
    done < <(read_packages "$DOTFILES/vscode/.config/Code/User/extensions")
  fi
fi

printf "\n  %s%s✓  done%s\n\n" "$GREEN" "$BOLD" "$RESET"

#!/usr/bin/env bash

# Shared utilities sourced by install.sh, link.sh, and unlink.sh.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Catppuccin Macchiato
readonly MAUVE=$'\033[38;2;198;160;246m'
readonly GREEN=$'\033[38;2;166;218;149m'
readonly RED=$'\033[38;2;237;135;150m'
readonly TEAL=$'\033[38;2;139;213;202m'
readonly DIM=$'\033[38;2;128;135;162m'
readonly TEXT=$'\033[38;2;202;211;245m'
readonly BOLD=$'\033[1m'
readonly RESET=$'\033[0m'

banner() {
  printf "\n  %s%sdotfiles%s  %s/ %s%s\n" "$MAUVE" "$BOLD" "$RESET" "$DIM" "$1" "$RESET"
}

section() {
  printf "\n  %s%s%s%s\n\n" "$MAUVE" "$BOLD" "$1" "$RESET"
}

abort() {
  printf "\n  %s%s✗  %s%s\n\n" "$RED" "$BOLD" "$1" "$RESET"
  exit 1
}

# Read package names from a file, skipping comments and blank lines.
read_packages() {
  local file_path="$1"
  grep -v '^\s*#' "$file_path" | grep -v '^\s*$' | awk '{print $1}'
}

# Resolve the default Zen profile directory for the current platform.
# Returns the full path, or prints a warning and returns 1 if not found.
find_zen_profile() {
  local base_dir
  case "$(uname -s)" in
    Darwin) base_dir="$HOME/Library/Application Support/zen" ;;
    Linux)  base_dir="$HOME/.zen" ;;
    *) return 1 ;;
  esac

  local ini="$base_dir/profiles.ini"
  if [[ ! -f "$ini" ]]; then
    printf "    %s!%s  zen profiles.ini not found — open Zen, close it, then re-run\n" "$MAUVE" "$RESET"
    return 1
  fi

  local profile_path
  profile_path=$(awk '
    /^\[Profile/ {
      if (is_default && path != "") { print path; exit }
      is_default = 0; path = ""
    }
    /^Default=1$/ { is_default = 1 }
    /^Path=/      { path = substr($0, 6) }
    END           { if (is_default && path != "") print path }
  ' "$ini")

  [[ -n "$profile_path" ]] && echo "$base_dir/$profile_path"
}

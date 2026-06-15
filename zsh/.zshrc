# Fastfetch configuration
fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme configuration
for p10k_path in \
  /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme \
  /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme \
  /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
do
  if [[ -f "$p10k_path" ]]; then
    source "$p10k_path"
    break
  fi
done

[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh

# Syntax highlighting styles (must be set before sourcing zsh-syntax-highlighting)
[[ -f "$HOME/.syntax.zsh" ]] && source "$HOME/.syntax.zsh"

# History configuration
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Environment configuration
export EDITOR="code"
export LANG=en_AU.UTF-8

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"

for nvm_sh in \
  /usr/share/nvm/nvm.sh \
  /opt/homebrew/opt/nvm/nvm.sh \
  /usr/local/opt/nvm/nvm.sh
do
  if [[ -f "$nvm_sh" ]]; then
    source "$nvm_sh"
    break
  fi
done

for nvm_completion in \
  /usr/share/nvm/bash_completion \
  /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm \
  /usr/local/opt/nvm/etc/bash_completion.d/nvm
do
  if [[ -f "$nvm_completion" ]]; then
    source "$nvm_completion"
    break
  fi
done

# Zoxide (replaces cd)
eval "$(zoxide init zsh)"

# Thefuck
eval "$(thefuck --alias)"

# FZF key bindings and completion
for fzf_shell in \
  /usr/share/fzf \
  /opt/homebrew/opt/fzf/shell \
  /usr/local/opt/fzf/shell
do
  if [[ -d "$fzf_shell" ]]; then
    [[ -f "$fzf_shell/key-bindings.zsh" ]] && source "$fzf_shell/key-bindings.zsh"
    [[ -f "$fzf_shell/completion.zsh" ]] && source "$fzf_shell/completion.zsh"
    break
  fi
done

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

## fd configuration for FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

## Preview configuration for FZF
preview_prompt="if [ -d {} ]; then eza --color=always --tree {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$preview_prompt'"
export FZF_ALT_C_OPTS="--preview '$preview_prompt'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    export|unset) fzf --preview "eval 'echo $'{}" "$@" ;;
    ssh)          fzf --preview "dig {}"          "$@" ;;
    *)            fzf --preview "$preview_prompt" "$@" ;;
  esac
}

# Bat configuration
export BAT_THEME="Catppuccin Macchiato"

# Alias configuration
[[ -f "$HOME/.aliases.zsh" ]] && source "$HOME/.aliases.zsh"

# Autosuggestions
for zsh_autosuggestions_path in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  if [[ -f "$zsh_autosuggestions_path" ]]; then
    source "$zsh_autosuggestions_path"
    break
  fi
done

# Syntax highlighting — must be sourced last
for zsh_syntax_highlighting_path in \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  if [[ -f "$zsh_syntax_highlighting_path" ]]; then
    source "$zsh_syntax_highlighting_path"
    break
  fi
done

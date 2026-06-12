# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="robbyrussell"
[[ -f "$HOME/.syntax.zsh" ]] && source "$HOME/.syntax.zsh"

# History configuration
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Environment configuratoin
export EDITOR="code"
export LANG=en_AU.UTF-8

# Alias configuration
[[ -f "$HOME/.aliases.zsh" ]] && source "$HOME/.aliases.zsh"

# Plugin configuration
plugins=(
  git
  z
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"
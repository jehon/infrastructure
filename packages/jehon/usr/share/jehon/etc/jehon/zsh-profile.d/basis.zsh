#!/usr/bin/zsh

# shellcheck shell=bash # FIXME: shellcheck for zsh

## Handled by omz
# HISTSIZE=1000
# HISTFILESIZE=2000
# SAVEHIST=$HISTSIZE
# HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

setopt AUTO_CD
setopt CORRECT
# setopt CORRECT_ALL
# setopt histignoredups
# setopt hist_ignore_all_dups
# setopt SHARE_HISTORY
# setopt APPEND_HISTORY

# Will be overriden by omz!
# PROMPT='\n%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

#!/usr/bin/env bash

if [ "$(id -u)" -eq "0" ]; then
    # Not when root
    return
fi

echo "Loading jh-profile-dev: interactive"
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#
# Bash only
#
if [ -n "$BASH_VERSION" ]; then
    echo "Loading jh-profile-dev: interactive bash"

    # user@host / folder
    # shellcheck disable=SC2154
    export PS1='\n${debian_chroot:+(${debian_chroot})}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\] \$ '

    # don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000
fi # Bash only

# Loading direnv
# This will modify the prompt, so let's put this here
#   See https://github.com/direnv/direnv/commit/f5deb57e5944978c6a0017bbcb2a808e3e59fb21
#   Fix requires direnv 2.34.0 (2.32.1 at 2024-06-05)
if type direnv &>/dev/null; then
    declare -a PROMPT_COMMAND
    eval "$(direnv hook bash)"
    # Must be an array for /etc/profile.d/vte-2.91.sh
    # Since bash 5.1
    PROMPT_COMMAND=(_direnv_hook)
fi

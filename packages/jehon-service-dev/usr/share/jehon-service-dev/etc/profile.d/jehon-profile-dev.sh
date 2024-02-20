#!/usr/bin/env bash

if [ "$(id -u)" -eq "0" ]; then
    # Not when root
    return
fi

# See https://unix.stackexchange.com/a/26782/240487
# interactive => if [[ $- == *i* ]]
# login       => if shopt -q login_shell
if [[ $- != *i* ]]; then
    # TODO: It seem that it is not loaded by default, but to be checked
    # Not when non-interractive
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

if type lsd &>/dev/null; then
    alias ls='lsd'
    alias l='lsd -l'
fi

#
# Bash only
#
if [ -n "$BASH_VERSION" ]; then
    echo "Loading jh-profile-dev: interactive bash"

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    ############################
    #
    # PROMPT
    #
    __parse_git_branch() {
        if ! git branch >/dev/null 2>&1; then
            return
        fi

        REPO="$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")"
        BRANCH="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$(git status -s 2>/dev/null)" ]; then
            MODIF="*"
        fi

        printf "(%s: %s%s)" "$REPO" "$BRANCH" "$MODIF"
    }

    __cmd_result() {
        __LAST_RESULT="$?"
        case "$__LAST_RESULT" in
        0)
            # shellcheck disable=SC3037
            echo -ne "$JH_MSG_OK"
            ;;
        130)
            # Ctrl-C
            # shellcheck disable=SC3037
            echo -ne "\033[31m^C\033[00m"
            ;;
        *)
            # shellcheck disable=SC3037
            echo -ne "$JH_MSG_KO"
            ;;
        esac

        # shellcheck disable=2154 # (no undeclared variables)
        PS1="${PS1}${RCol}@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
    }

    # Start with a white line
    PS1=''
    # last command result / git status / screen id
    # !! enclose escape in \[xxx\] to avoid wrapping problems
    PS1=$PS1'\n$(__cmd_result) \[\033\][33m$(__parse_git_branch)\[\033\][\[00m\] ${STY:+(screen) }'

    # user@host / folder
    # shellcheck disable=SC2154
    PS1=$PS1'\n${debian_chroot:+(${debian_chroot})}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\] \$ '
    export PS1

    #
    #
    # Take over .bashrc
    #
    #

    # don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # Handled by /etc/profile.d/bash_completion.sh (from bash-completion)
    # # enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # # sources /etc/bash.bashrc).
    # if ! shopt -oq posix; then
    #     if [ -f /usr/share/bash-completion/bash_completion ]; then
    #         # shellcheck source=/dev/null
    #         . /usr/share/bash-completion/bash_completion
    #     elif [ -f /etc/bash_completion ]; then
    #         # shellcheck source=/dev/null
    #         . /etc/bash_completion
    #     fi
    # fi
fi # Bash only

# Loading direnv
# This will modify the prompt, so let's put this here
if type direnv &>/dev/null; then
    declare -a PROMPT_COMMAND
    eval "$(direnv hook bash)"
    # Must be an array for /etc/profile.d/vte-2.91.sh
    # Since bash 5.1
    PROMPT_COMMAND=( _direnv_hook )
fi

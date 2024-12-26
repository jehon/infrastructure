# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# shellcheck shell=bash # FIXME: shellcheck for zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

plugins=(
    aws
    direnv
    git
    terraform
)

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

if [ ! -r $ZSH/oh-my-zsh.sh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    echo "# Truncated by omz.zsh profile on initial install" >$HOME/.zshrc
fi

if [ -r $ZSH/oh-my-zsh.sh ]; then
    # Get our home zsh
    # Load profiles and set various default values
    source $ZSH/oh-my-zsh.sh

    #
    # We could reevaluate at each run by \$( xxx )
    #   See https://stackoverflow.com/a/69652752/1954789
    #

    #
    # Customize right prompt status (override)
    #
    JH_PROMPT_STATUS=""
    jh_custom_status() {
        if [ -n "$JH_PROMPT_STATUS" ]; then
            echo "$JH_PROMPT_STATUS"
        fi
        if [ -n "$JAVA_HOME" ] && [ -r $JAVA_HOME/release ]; then
            (
                . $JAVA_HOME/release
                echo " jdk:$JAVA_VERSION"
            )
        fi
        if jh-aws-authenticated; then
            echo " aws-mfa"
        fi
    }
    RPROMPT="$RPROMPT \$(jh_custom_status)"
else
    echo "Could not load oh-my-zsh in $ZSH/oh-my-zsh.sh. Continuing..." >&2
fi

unsetopt share_history

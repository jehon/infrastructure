#!/usr/bin/env sh

#
# Bash load this only on login shell
# Zsh load it through zshrc, so it is an interactive shell
#

#
#
# Used by both bash (/etc/profile.d/jehon-common.sh) and zsh (/etc/zsh/zshrc ???)
#
#

# For pip (python) local install
export PATH=~/.local/bin/:~/bin:"$PATH"

# Production variables
export PYTHONPATH="$PYTHONPATH:/usr/lib/python3/dist-packages:/var/lib/python/jehon"

TZ="$(cat /etc/timezone)"
export TZ

# You may need to manually set your language environment
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

# Remove the ExperimentalWarning:...
#   https://stackoverflow.com/a/70755170/1954789
export NODE_NO_WARNINGS=1

# Import setup-profile.sh everywhere
if [ -r ~/src ]; then
    while read -r F; do
        # No pipe or fancy, otherwise no include...

        # shellcheck source=/dev/null
        source "$F"
    done < <(find ~/src \
        -type d \( -name "node_modules" -o -name "vendor" -o -name "tmp" \) -prune -false \
        -o -name "setup-profile.sh")
fi

#!/usr/bin/env bash

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

TZ="$(timedatectl show --value --property=Timezone)"
export TZ

# You may need to manually set your language environment
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

# Remove the ExperimentalWarning:...
#   https://stackoverflow.com/a/70755170/1954789
export NODE_NO_WARNINGS=1

# Import setup-profile.sh everywhere
if [ -r ~/koalty ]; then
	function jhAddPathToProfile() {
		local lpath
		lpath="$(pwd)/$1"
		if [ ! -r "$lpath" ]; then
			echo "Path: + '$lpath' not found"
		else
			echo "Path: + '$lpath'"
			export PATH="$lpath:$PATH"
		fi
	}

	while read -r F; do
		# No pipe or fancy, otherwise no include...

		cd "$(dirname "$F")" >/dev/null || true
		# shellcheck source=/dev/null
		source "$F" || true
		cd - >/dev/null || true
	done < <(find ~/koalty \
		-type d \( -name "node_modules" -o -name "vendor" -o -name "tmp" \) -prune -false \
		-o -name "setup-profile.sh")
fi

#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_PKG_FOLDER"/packages/jehon/usr/bin/jh-lib

clear

TEST="$JH_PKG_FOLDER/tmp/pcloud"

if [ -n "$RESET" ]; then
	rm -fr "$TEST"
	mkdir -p "$TEST"

	pushd "$TEST"

	mkdir -p "Storage"
	echo "123" >pcloud-backup
	touch --date "Tue, 22 Mar 2022 09:29:36" pcloud-backup
	ls -l pcloud-backup

	# Extra files
	echo "123" >root-local-file
	echo "123" >Storage/local-file
else
	pushd "$TEST"
fi

# TODO: this will not work! it need authentication!
echo "------------------------"
"$JH_PKG_FOLDER"/bin/jh-pcloud "$@"

ls -l "$TEST"

echo "ok"

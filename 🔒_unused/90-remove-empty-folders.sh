#!/usr/bin/env bash

set -o errexit
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR/../
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/../lib.sh

EADIR="@eaDir"

if_is_empty_folder() {
	local FOLDER="$1"
	local NOT_EMPTY=0

	local F
	for F in "${FOLDER}"/*; do
		local BASENAME="$(basename "$F")"

		if [ -d "$F" ]; then
			case "${BASENAME}" in
			"." | "..")
				continue
				;;
			"${EADIR}")
				# We don't count EADIR
				continue
				;;
			esac

			if if_is_empty_folder "$F"; then
				echo rm -fr "$F"
				continue
			fi
			# We have a non-empty folder
		fi
		# We have something not empty
		NOT_EMPTY=1
	done
	return "${NOT_EMPTY}"
}

# if_is_empty_folder "${MAIN_VOLUME}/Documents"    || true
if_is_empty_folder "${MAIN_VOLUME}/Photos" || true
# if_is_empty_folder "${MAIN_VOLUME}/Musiques"     || true
# if_is_empty_folder "${MAIN_VOLUME}/Videos"       || true
# if_is_empty_folder "${MAIN_VOLUME}/photo/public" || true

echo "** Done"

#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

"$SCRIPTS_FOLDER"/daily.d/80-photo-gallery.sh

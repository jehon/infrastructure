#!/usr/bin/env bash

set -o errexit

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

# Script Working Directory
TWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

#
# We need to re-import it for JH_SWD to be set correctly
#
# shellcheck source=SCRIPTDIR/../../packages/jehon/usr/bin/jh-lib
. "$JH_PKG_FOLDER/packages/jehon/usr/bin/jh-lib"

assert_equals "JH_SWD" "$TWD" "$JH_SWD"

assert_file_exists "/etc/hosts"

if ok_ko "test" true >/dev/null 2>&1; then ok "test ok_ko true"; else false; fi
if ok_ko "test" false >/dev/null 2>&1; then false; else ok "test ok_ko false"; fi
if ok_ko "test" ls /etc >/dev/null 2>&1; then ok "test ok_ko ls /etc"; else false; fi
if ok_ko "test" ls /anything >/dev/null 2>&1; then false; else ok "test ok_ko ls /anything"; fi
if ok_ko "test" "[ 1 == 1 ]"; then ok "test ok_ko 1 == 1"; else false; fi

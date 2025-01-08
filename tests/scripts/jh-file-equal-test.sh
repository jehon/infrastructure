#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

F1="${JH_TEST_TMP}/f1"
F2="${JH_TEST_TMP}/f2"
echo 1 >"${F1}"
sleep 1s
echo 1 >"${F2}"

header_begin "Special cases"
(! jh-file-equal "${JH_TEST_TMP}/does-not-exists" "/etc/hosts")
(! jh-file-equal "/etc/hosts" "${JH_TEST_TMP}/does-not-exists")
(! jh-file-equal "${JH_TEST_TMP}/does-not-exists" "${JH_TEST_TMP}/does-not-exists")
jh-file-equal "/tmp" "/tmp"
header_end

header_begin "Compare normal cases"
jh-file-equal "/etc/hosts" "/etc/hosts"
(! jh-file-equal "/etc/hosts" "/etc/group")

(! jh-file-equal "$F1" "$F2")

# touch --reference="$F1" "$F2"
rsync --times "$F1" "$F2"
jh-file-equal "$F1" "$F2"

header_end

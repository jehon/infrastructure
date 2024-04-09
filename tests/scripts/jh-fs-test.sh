#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/lib-scripts-helpers.sh"

SCRIPT="$JH_PKG_FOLDER"/packages/jehon/usr/bin/jh-fs

assert_equals "name" "name"    "$($SCRIPT "name" "/etc/name.conf")"
assert_equals "name" "another" "$($SCRIPT "name" "/etc/another")"
assert_equals "name" "etc"     "$($SCRIPT "name" "/etc/")"
assert_equals "name" "conf"    "$($SCRIPT "name" "/etc/conf")"

assert_equals "extension" "ext" "$($SCRIPT "extension" "/etc/conf.ext")"
assert_equals "extension" ""    "$($SCRIPT "extension" "/etc/conf")"
assert_equals "extension" ""    "$($SCRIPT "extension" "/etc/")"

assert_equals "to-extension" "/etc/conf.test" "$($SCRIPT "to-extension" "/etc/conf.conf" ".test")"
assert_equals "to-extension" "/etc/conf.test" "$($SCRIPT "to-extension" "/etc/conf" ".test")"
assert_equals "to-extension" "/etc.test"      "$($SCRIPT "to-extension" "/etc/" ".test")"

assert_success "not-empty" "$SCRIPT" "not-empty" "/etc/"
assert_failure "not-empty" "$SCRIPT" "not-empty" "/etc/anything"

assert_failure "is-empty" "$SCRIPT" "is-empty" "/etc/"
assert_success "is-empty" "$SCRIPT" "is-empty" "/etc/anything"

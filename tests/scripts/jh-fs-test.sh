#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

script="$JH_PKG_FOLDER"/packages/jehon/usr/bin/jh-fs

assert_equals "name" "name" "$("${script}" "name" "/etc/name.conf")"
assert_equals "name" "another" "$("${script}" "name" "/etc/another")"
assert_equals "name" "etc" "$("${script}" "name" "/etc/")"
assert_equals "name" "conf" "$("${script}" "name" "/etc/conf")"

assert_equals "extension" "ext" "$("${script}" "extension" "/etc/conf.ext")"
assert_equals "extension" "" "$("${script}" "extension" "/etc/conf")"
assert_equals "extension" "" "$("${script}" "extension" "/etc/")"

assert_equals "to-extension" "/etc/conf.test" "$("${script}" "to-extension" "/etc/conf.conf" ".test")"
assert_equals "to-extension" "/etc/conf.test" "$("${script}" "to-extension" "/etc/conf" ".test")"
assert_equals "to-extension" "/etc.test" "$("${script}" "to-extension" "/etc/" ".test")"

assert_success "not-empty" "${script}" "not-empty" "/etc/"
assert_failure "not-empty" "${script}" "not-empty" "/etc/anything"

assert_failure "is-empty" "${script}" "is-empty" "/etc/"
assert_success "is-empty" "${script}" "is-empty" "/etc/anything"

assert_equals "file-to-path" "/etc/apt/sources.list.d/jehon-hashicorp.sources" "$("${script}" "file-to-path" "jehon/scripts/hooks/etc_apt_sources.list.d_jehon-hashicorp.sources")"

assert_equals "path-to-file" "etc_apt_sources.list.d_jehon-hashicorp.sources" "$("${script}" "path-to-file" "/etc/apt/sources.list.d/jehon-hashicorp.sources")"

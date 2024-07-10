#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../test-helpers.sh"

mkdir -p "${JH_TEST_TMP}"

PATCH="$JH_TEST_TMP/jh-patch-patch.txt"
TARGET="$JH_TEST_TMP/jh-patch-original.txt"
BACKUP="$TARGET-before-patch"

(
	# Setup the source file
	echo "This is the file"
	echo "This is the end"
) >"$TARGET"

cat <<-EOF >"$PATCH"
	Hello world
EOF

assert_success "jh-patch" "$prjRoot"/packages/jehon/usr/bin/jh-patch "$TARGET" "tag" "$PATCH"

test_capture "jh-patch-patch read" cat "$TARGET"
assert_captured_output_contains "Live source: $PATCH"
test_capture_empty
assert_true "The backup file $BACKUP exists" "$([[ -r "$BACKUP" ]])"

test_capture_file "read the generated file" "$TARGET"
assert_captured_output_contains "This is the file"
assert_captured_output_contains "Hello world"
test_capture_empty

assert_success "jh-patch-patch" "$prjRoot"/packages/jehon/usr/bin/jh-patch "$TARGET" "tag"

test_capture_file "read the generated file" "$TARGET"
assert_captured_output_contains "This is the file"
assert_true "Should not contain patch" "$([[ $(grep "Hello world" "$TARGET") = "" ]])"
test_capture_empty

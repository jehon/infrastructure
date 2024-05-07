#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/test-lib.sh

build_run_env ""

# pwd does not end with / :-)
TO="$(pwd)"
FROM="${TO}-from"

rm -fr "${FROM}"
mv -v "${TO}" "${FROM}"
mkdir "${TO}"

fo_run select --to "${TO}" --amount 2 "${FROM}"

# cd "${TO}"
# assert_equals "Number of files" "7" "$( find "." -type f | wc -l )"

# assert_exists "2019-01-02 03-04-05 1 [ts-guessed].jpg"
# assert_exists "2019-09-19 07-48-25 [DSC_2506].mov"
# assert_exists "2018-01-02 03-04-05 My title [my original name].jpg"

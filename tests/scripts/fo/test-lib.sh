#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

JH_TEST_NAME="system/fo/$( basename "$0" )"

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../../test-helpers.sh"

FO="${JH_PKG_FOLDER}/bin/fo"
# "${FO}" -h

ORIGINAL_DATA="${JH_SWD}/data"

#######################################
#
# References
#
#

declare -a REF_LIST
declare -A REF_TIME
declare -A REF_DESC

add_ref() {
    REF_LIST+=( "$1" )
    REF_TIME+=( [$1]="$2" )
    REF_DESC+=( [$1]="$3" )
}

add_ref "basic/2018-01-02 03-04-05 my title [my original name].jpg" "2018:01:02 03:04:05" "my comment"
add_ref "basic/DSC_2506.MOV" "2019:09:19 07:48:25" ""
add_ref "basic/IMG_20190324_121437.jpg" "2019:03:24 12:14:38" ""
add_ref "basic/VID_20190324_121446.mp4" "2019:03:24 11:14:46" ""
add_ref "basic/2021-01-04 01-02-03 Vie de famille.jpg" "2021:01:04 01:02:03" "Vie de famille"
add_ref "2019 test/1.jpeg" "0000:00:00 00:00:00" ""
add_ref "2019 test/DSC_2506.MOV" "2019:09:19 07:48:25" ""

ref_time() {
    echo "${REF_TIME[$1]}"
}

ref_desc() {
    echo "${REF_DESC[$1]}"
}

file_handled() {
    REF="$1"
    # Remove from list to allow assert_other_untouched
    declare -a NR
    for I in "${!REF_LIST[@]}" ; do
        if [ "${REF_LIST[$I]}" != "$REF" ]; then
            NR+=( "${REF_LIST[$I]}" )
        fi
    done
    REF_LIST=( "${NR[@]}" )
}

#######################################
#
# Run
#
#
fo_run_raw() {
    "${FO}" "$@"
}

fo_run() {
    (
        fo_run_raw "$@"
    ) |& jh-tag-stdin "run"
}

build_run_env() {
    SOURCE_PATH="${ORIGINAL_DATA}"
    if [ -n "$1" ]; then
        SOURCE_PATH="${JH_TEST_TMP}/../$1"
    fi

    jh_info "From: ${SOURCE_PATH} To: ${JH_TEST_TMP}"
    mkdir -p "${JH_TEST_TMP}"
    rsync \
        -a --no-perms \
        --delete \
        "${SOURCE_PATH}/" \
        "${JH_TEST_TMP}"

    cd "${JH_TEST_TMP}"
}

###################################
#
# Asserts
#
#

assert_exif_field() {
    local FILE="$1"
    local FIELD="$2"
    local REF="$3"

    local VAL
    VAL="$(fo_run_raw info -k "${FIELD}" "${FILE}" )"
    assert_equals "${1} # ${FIELD}" "${REF}" "${VAL}"
}

assert_exists() {
    assert_file_exists "$1"
}

assert_exif_time() {
    assert_exif_field "$1" "i_fe_time" "$2"
}

assert_exif_desc() {
    assert_exif_field "$1" "i_fe_title" "$2"
}

assert_untouched() {
    local F="$1"
    (
        assert_exists "$F"
        assert_exif_time "$F" "$( ref_time "$F" )"
        assert_exif_desc "$F" "$( ref_desc "$F" )"
    ) 3>&1 |& jh-tag-stdin "untouched"
}

assert_file() {
    local F="$1"
    local REF="$2"
    local TIME="$3"
    local DESC="$4"

    assert_exists "$F"

    if [ "$TIME" == "REF" ]; then
        assert_exif_time "$F" "$( ref_time "$REF" )"
    else
        assert_exif_time "$F" "${TIME}"
    fi

    if [ "${DESC}" == "REF" ]; then
        assert_exif_desc "$F" "$( ref_desc "$REF" )"
    else
        assert_exif_desc "$F" "${DESC}"
    fi

    file_handled "${REF}"
}

assert_others_untouched() {
    (
        local F
        for F in "${REF_LIST[@]}" ; do
            assert_untouched "$F"
        done
    ) 3>&1 |& jh-tag-stdin "all"
}
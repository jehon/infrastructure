#!/usr/bin/env bash

set -o errexit
set -o pipefail

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../../../bin/lib.sh"

# TODO: make clean should remove all this...

# shellcheck disable=SC2120
# shellcheck disable=SC2119
run_in_docker() {
    DOCKER_IMAGE="${1:?Need image as [1]}"
    # TODO: Fix this
    TEST_FILE="${2:?Specify test name}"

    TEST_NAME="$(basename "${TEST_FILE}")"
    TEST_SUITE="$(basename "$(dirname "${TEST_FILE}")")"
    DOCKER_TAG="test-infrastructure-${TEST_SUITE}:${TEST_NAME}"

    (
        echo "*******************************************************"
        echo "* Docker Tag:     ${DOCKER_TAG}"

        docker kill "${DOCKER_TAG}" &>/dev/null || true
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true

        # Build from swd...
        docker build \
            --build-arg "SOURCE=${DOCKER_IMAGE}" \
            --build-context "publish=${JH_PKG_FOLDER}/tmp/publish" \
            --tag "${DOCKER_TAG}" \
            "${_SD}" |& jh-tag-stdin "building"

        (
            cat <<-'EOS'
			set -o errexit
			set -o pipefail

            echo "----------- script -------------------------"
		EOS
            cat -
            cat <<-'EOS'
			echo

            echo "----------- checks -------------------------"
			find /lib/systemd \
			    -type f -name "jh*.service" \
			    -exec systemd-analyze verify "{}" "+"
            echo "----------- done ---------------------------"
		EOS
        ) | docker run --label temp \
            -v "${JH_PKG_FOLDER}:/workspace" \
            --rm -i --privileged "${DOCKER_TAG}" |&
            jh-tag-stdin "inside" || jh_fatal "!! Test failed: ${TEST_SUITE}/${TEST_NAME} ($?) !!"

        echo "ok"
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true
    ) | jh-tag-stdin "${TEST_SUITE}/${TEST_NAME}"
}

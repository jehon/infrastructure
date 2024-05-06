#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../../../bin/lib.sh"

# TODO: make clean should remove all this...

run_in_docker() {
    # Avoid override in other scripts
    _SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    DOCKER_IMAGE="${1:?Need image as [1]}"
    # Test name is taken from the initial run file
    # So we must run it as is (not sourced)
    TEST_FILE="$0"

    TEST_NAME="$(basename "${TEST_FILE}")"
    TEST_SUITE="$(basename "$(dirname "${TEST_FILE}")")"
    DOCKER_TAG="test-infrastructure-${TEST_SUITE}:${TEST_NAME}"

    {
        echo "*******************************************************"
        echo "* Docker Tag:     ${DOCKER_TAG}"

        docker kill "${DOCKER_TAG}" &>/dev/null || true
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true

        # Build from swd...
        docker build \
            --build-arg "SOURCE=${DOCKER_IMAGE}" \
            --build-context "publish=${JH_PKG_FOLDER}/tmp/publish" \
            --tag "test-docker" \
            "${_SD}" |& jh-tag-stdin "building"

        {
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
        } | docker run --label "${DOCKER_TAG}" \
            -v "${JH_PKG_FOLDER}:/workspace" \
            --rm -i --privileged "test-docker" |&
            jh-tag-stdin "inside" || jh_fatal "!! Test failed: ${TEST_SUITE}/${TEST_NAME} ($?) !!"

        echo "ok"
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true
    } | jh-tag-stdin "${TEST_SUITE}/${TEST_NAME}"
}

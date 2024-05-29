#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. "$(dirname "${BASH_SOURCE[0]}")/../../../bin/lib.sh"

# TODO: make clean should remove all this...

export baseImage="test-docker-basis"
export baseImageWithSetup="test-docker-setup"

# Avoid override in other scripts
LIB_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

run_in_docker() {
    # Avoid override in other scripts
    _SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    # Test name is taken from the initial run file
    # So we must run it as is (not sourced)
    TEST_FILE="$0"
    TEST_NAME="$(basename "${TEST_FILE}")"
    TEST_SUITE="$(basename "$(dirname "${TEST_FILE}")")"
    DOCKER_TAG="test-infrastructure-${TEST_SUITE}:${TEST_NAME}"

    runBaseImage="${1:-"${baseImage}"}"

    {
        case ${runBaseImage} in
        "${baseImage}")
            buildTarget="basis"
            ;;
        "${baseImageWithSetup}")
            buildTarget="basisWithSetup"
            ;;
        *)
            jh_fatal "base image unknown: ${runBaseImage}"
            ;;
        esac

        echo "*******************************************************"
        echo "* Docker Image:     ${runBaseImage}"
        echo "* Docker Tag:       ${buildTarget}"
        echo "* Docker Tag:       ${DOCKER_TAG}"

        docker build \
            --build-context "publish=${JH_PKG_FOLDER}/tmp/publish" \
            --build-context "workspace=${JH_PKG_FOLDER}" \
            --tag "${runBaseImage}" \
            --target "${buildTarget}" \
            "${LIB_SD}" |& jh-tag-stdin "run.sh building ${runBaseImage}"

        docker kill "${DOCKER_TAG}" &>/dev/null || true
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true

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
            --rm -i --privileged "${runBaseImage}" |&
            jh-tag-stdin "inside" || jh_fatal "!! Test failed: ${TEST_SUITE}/${TEST_NAME} ($?) !!"

        echo "ok"
        docker rm -f "${DOCKER_TAG}" &>/dev/null || true
    } | jh-tag-stdin "${TEST_SUITE}/${TEST_NAME}"
}

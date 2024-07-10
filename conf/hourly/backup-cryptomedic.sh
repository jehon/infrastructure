#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

_SD="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck source-path=SCRIPTDIR/
. "${_SD}/../../bin/lib.sh"

# shellcheck source-path=SCRIPTDIR/../../
. "${prjRoot}"/bin/jh-run-only-daily

target="${jhCloudFolderInUserHome}"/Systèmes/cryptomedic/backups/

# shellcheck source-path=SCRIPTDIR/../../
"${prjRoot}"/bin/jh-wait-home-cloud "${target}"

# shellcheck source=/dev/null
. "$HOME"/restricted/cryptomedic.sh

echo "Generating a new backup on remote"
curl -fsSL "http://${CRYPTOMEDIC_DEPLOY_WEB_HOST}/maintenance/create_db_backup.php?pwd=${CRYPTOMEDIC_DEPLOY_WEB_TOKEN}"
echo "- Sleeping a bit to allow the file to become visible"
sleep 10s
echo "...done"

echo "Getting storage"
lftp "${CRYPTOMEDIC_DEPLOY_FILES_USER}:${CRYPTOMEDIC_DEPLOY_FILES_PASSWORD=}@${CRYPTOMEDIC_DEPLOY_FILES_HOST}" \
    -e "set net:limit-rate 200k; mirror live/ '$target/'; bye"
echo "...done"

ok "Backup finished with success"

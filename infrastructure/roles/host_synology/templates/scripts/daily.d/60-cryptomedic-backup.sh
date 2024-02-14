#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR/../
. "$(dirname "$( realpath "${BASH_SOURCE[0]}")")"/../lib.sh

# shellcheck source-path=SCRIPTDIR/../
. "$SCRIPTS_FOLDER"/config/cryptomedic.sh

BACKUP_DIR="$MAIN_VOLUME"/Backups/cryptomedic/

mkdir -p "$BACKUP_DIR"

echo "Generating a new backup on remote"
curl -fsSL "http://$CRYPTOMEDIC_HTTP_HOST/maintenance/create_db_backup.php?pwd=$CRYPTOMEDIC_HTTP_TOKEN"
echo "- Sleeping a bit to allow the file to become visible"
sleep 10s
echo "...done"

echo "Getting storage"
lftp "$CRYPTOMEDIC_DEPLOY_USER:$CRYPTOMEDIC_DEPLOY_PASSWORD@$CRYPTOMEDIC_DEPLOY_HOST" \
	-e "mirror live/ '$BACKUP_DIR/'; bye"
echo "...done"

echo "Backup finished with success"

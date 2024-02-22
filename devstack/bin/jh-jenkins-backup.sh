#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

# shellcheck source-path=SCRIPTDIR
. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/jenkins-lib.sh

CONFIG="$JENKINS_ROOT/config"
EXPORT="$JENKINS_TMP/export"

echo "## Extract configs (into $EXPORT)..."
rm -fr "$EXPORT"
mkdir -p "$EXPORT"
runDockerCompose cp jenkins:/var/jenkins_home/ "$EXPORT/"
echo "## Extract configs (into $EXPORT) done"

rsyncCopy() {
    NAME="$1"
    shift
    echo "### $NAME"
    rsync --prune-empty-dirs --archive \
        --delete --delete-excluded \
        "$@" \
        "$EXPORT/jenkins_home/$NAME/" "$CONFIG/raw/$NAME/"
}

echo "## Backup raw data..."
rsyncCopy "jobs" \
    --exclude "changelog.xml" --exclude "builds" \
    --include="*.xml" --include="*/" \
    --exclude="*" \

rsyncCopy "nodes"

rsyncCopy "users" \
    --exclude apiTokenStats.xml

rsyncCopy "secrets" \
    --exclude master.key

echo "### others xml"
cp "$EXPORT/jenkins_home/"*.xml "$CONFIG/raw/"
echo "## Backup raw data done"

jenkins_check

echo "## Building plugins list..."
(
    # https://github.com/jenkinsci/docker/blob/master/README.md

    # curl -sSL "http://127.0.0.1:8080/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" \
    #     | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'

    cat <<"EOS" | jenkins_cli groovy "="
import jenkins.model.Jenkins;

Jenkins.instance.pluginManager.plugins
    .collect()
    .sort { it.getShortName() }
    .each {
        plugin -> println("${plugin.getShortName()}:${plugin.getVersion()}")
    }
EOS

) | tee "$EXPORT"/plugins.tmp | sed "s/:.*//" >"$CONFIG"/plugins.raw.txt
echo "## Building plugins list done"

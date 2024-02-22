#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR
. "$( dirname "$( realpath "${BASH_SOURCE[0]}")")"/lib.sh

export JENKINS_ROOT="$PRJ_ROOT/jenkins"
export JENKINS_TMP="$PRJ_TMP/jenkins"
export JENKINS_JAR="$TMP/jenkins-cli.jar"
export JENKINS_DOCKER_NAME="jenkins"
export JENKINS_GUEST_HOME="/var/jenkins_home"
export JENKINS_URL="http://localhost/jenkins/"

mkdir -p "$JENKINS_TMP"

if [ -r ~/restricted/jenkins.env ]; then
    # shellcheck source=/dev/null
    . ~/restricted/jenkins.env
fi

jenkins_cli() {
    # Need JENKINS_URL

    if [ ! -r "$JENKINS_JAR" ]; then
        echo -n "Getting jenkins-cli.jar"
        while ! curl -fsSL "$JENKINS_URL"/jnlpJars/jenkins-cli.jar --output "$JENKINS_JAR" &>/dev/null; do
            sleep 1
            echo -n "."
        done
        echo " done"
    fi

    java -jar "$JENKINS_JAR" -s "$JENKINS_URL" -webSocket -auth "${JENKINS_SYSTEM_USER}:${JENKINS_SYSTEM_KEY}" "$@"
}

jenkins_check() {
    echo "## Testing connectivity..."
    jenkins_cli "who-am-i"
    echo "## Testing connectivity done"
}

#!/usr/bin/env bash

set -o errexit
set -o pipefail

# shellcheck source-path=SCRIPTDIR
. jh-lib

NAME="$1"
[ -n "$1" ] || jh_fatal "Must specify slave name"

JENKINS_URL="http://127.0.0.1:8080/jenkins"
WORKDIR="/mnt/jenkins/slaves/$NAME"
JAR="$WORKDIR.jar"

mkdir -p "$WORKDIR"

echo "Getting agent jar"
while ! curl --silent --output "$JAR" "$JENKINS_URL"/jnlpJars/agent.jar; do
	echo -n '.'
done
echo ""

java -jar "$JAR" -jnlpUrl "$JENKINS_URL/manage/computer/$NAME/jenkins-agent.jnlp" -workDir "$WORKDIR"

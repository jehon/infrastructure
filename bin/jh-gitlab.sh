#!/usr/bin/env bash

GITLAB_TOKEN_CACHE="$HOME/restricted/gitlab.key"

gitlabCall() {
    URL="$1"
    shift

    curl -fsSl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$@" \
        "$GITLAB_HOST/api/v4${URL}"
}

#
# Load and check the Gitlab Token
#
if [ -r "${GITLAB_TOKEN_CACHE}" ]; then
    GITLAB_TOKEN="$( cat "${GITLAB_TOKEN_CACHE}" )"

    GITLAB_USER="$( gitlabCall "/user" | jq -r ".username")"
    if [ -n "${GITLAB_USER}" ] ; then
        echo "You are connected as: ${GITLAB_USER}"
        return
    fi

    echo "Your token is invalid. Generating a new one."
fi

GITLAB_TOKEN=$( ssh git@gitlab.redange.fr-team.lu personal_access_token "shell" api \
    | grep Token \
    | cut -d ":" -f 2 \
    | tr -s '[:blank:]'
)

mkdir -p "$( dirname "${GITLAB_TOKEN_CACHE}" )"
echo "${GITLAB_TOKEN}" > "${GITLAB_TOKEN_CACHE}"

if [ -n "$1" ]; then
    gitlabCall "$@"
fi

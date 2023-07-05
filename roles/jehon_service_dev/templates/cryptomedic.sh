#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export CRYPTOMEDIC_HTTP_HOST="{{jehon.credentials.cryptomedic.http_host}}"
export CRYPTOMEDIC_HTTP_PORT="{{jehon.credentials.cryptomedic.http_port}}"
export CRYPTOMEDIC_HTTP_TOKEN="{{jehon.credentials.cryptomedic.http_token}}"

export CRYPTOMEDIC_DEPLOY_HOST="{{jehon.credentials.cryptomedic.deploy_host}}"
export CRYPTOMEDIC_DEPLOY_USER="{{jehon.credentials.cryptomedic.deploy_user}}"
export CRYPTOMEDIC_DEPLOY_PASSWORD="{{jehon.credentials.cryptomedic.deploy_password}}"

if [ -n "$1" ]; then
    "$@"
fi

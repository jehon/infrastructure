#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export CRYPTOMEDIC_DEPLOY_WEB_HOST="{{jehon.credentials.cryptomedic.deploy_web_host}}"
export CRYPTOMEDIC_DEPLOY_WEB_PORT="{{jehon.credentials.cryptomedic.deploy_web_port}}"
export CRYPTOMEDIC_DEPLOY_WEB_TOKEN="{{jehon.credentials.cryptomedic.deploy_web_token}}"

export CRYPTOMEDIC_DEPLOY_FILES_HOST="{{jehon.credentials.cryptomedic.deploy_files_host}}"
export CRYPTOMEDIC_DEPLOY_FILES_USER="{{jehon.credentials.cryptomedic.deploy_files_user}}"
export CRYPTOMEDIC_DEPLOY_FILES_PASSWORD="{{jehon.credentials.cryptomedic.deploy_files_password}}"

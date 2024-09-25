#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export CRYPTOMEDIC_DEPLOY_WEB_HOST="{{jehon_remote_cryptomedic_deploy_web_host}}"
export CRYPTOMEDIC_DEPLOY_WEB_PORT="{{jehon_remote_cryptomedic_deploy_web_port}}"
export CRYPTOMEDIC_DEPLOY_WEB_TOKEN="{{jehon_remote_cryptomedic_deploy_web_token}}"

export CRYPTOMEDIC_DEPLOY_FILES_HOST="{{jehon_remote_cryptomedic_deploy_files_host}}"
export CRYPTOMEDIC_DEPLOY_FILES_USER="{{jehon_remote_cryptomedic_deploy_files_user}}"
export CRYPTOMEDIC_DEPLOY_FILES_PASSWORD="{{jehon_remote_cryptomedic_deploy_files_password}}"

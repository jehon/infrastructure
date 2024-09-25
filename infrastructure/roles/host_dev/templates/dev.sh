#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export JH_DOCKER_HUB_TOKEN="{{ jehon_remote_docker_token }}"

export JH_PASS_PCLOUD_RO_CLIENT_ID="{{ jehon_remote_pcloud_ro_client_id }}"
export JH_PASS_PCLOUD_RO_CLIENT_SECRET="{{ jehon_remote_pcloud_ro_client_secret }}"
export JH_PASS_PCLOUD_RW_CLIENT_ID="{{ jehon_remote_pcloud_rw_client_id }}"
export JH_PASS_PCLOUD_RW_CLIENT_SECRET="{{ jehon_remote_pcloud_rw_client_secret }}"

#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export JH_DOCKER_HUB_TOKEN="{{ jehon.credentials.docker.token }}"

export JH_PASS_PCLOUD_RO_CLIENT_ID="{{ jehon.credentials.pcloud.ro.client_id }}"
export JH_PASS_PCLOUD_RO_CLIENT_SECRET="{{ jehon.credentials.pcloud.ro.client_secret }}"
export JH_PASS_PCLOUD_RW_CLIENT_ID="{{ jehon.credentials.pcloud.rw.client_id }}"
export JH_PASS_PCLOUD_RW_CLIENT_SECRET="{{ jehon.credentials.pcloud.rw.client_secret }}"

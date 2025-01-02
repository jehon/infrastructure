#!/usr/bin/env zsh

# shellcheck shell=bash # FIXME: shellcheck for zsh

cd /srv/stack || true

docker compose ps

#!/usr/bin/env bash

clear

set -o errexit
set -o pipefail

if [ -z "$1" ]; then
    ./bin/jh-infrastructure setup dev
fi

cat <<EOS | ssh root@localhost

systemctl restart grafana-agent.service || true
journalctl -xfu grafana-agent.service

EOS

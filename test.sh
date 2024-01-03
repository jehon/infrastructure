#!/usr/bin/env bash

clear

set -o errexit
set -o pipefail

if [ -z "$1" ]; then
    ./bin/jh-infrastructure setup dev
fi

cat <<EOS | ssh root@localhost

systemctl restart grafana-agent-flow.service || true
journalctl -xfu grafana-agent-flow.service

EOS

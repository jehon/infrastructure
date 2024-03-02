#!/usr/bin/env bash

clear

set -o errexit
set -o pipefail

if [ -z "$1" ]; then
#    ./bin/jh-infrastructure setup dev
    ./packages-deploy-patch.sh dev packages/jehon/usr/lib/systemd/system/mnt-hardware.mount
fi

cat <<EOS | ssh root@localhost

systemctl daemon-reload
systemctl restart mnt-hardware.mount
sleep 1
systemctl status mnt-hardware.mount

EOS

ls /mnt/hardware

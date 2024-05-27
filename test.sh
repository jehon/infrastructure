#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

rm -fr tmp/node/built/.built
make tmp/node/built/.built

target=kiosk
service=getty@tty1.service

./deploy-patch-from-packages "${target}" packages/jehon/usr/bin/jh-fo
./deploy-patch-from-packages "${target}" packages/jehon-service-kiosk/usr/lib/systemd/system/jehon-kiosk.service
./deploy-patch-from-packages "${target}" packages/jehon-service-kiosk/usr/lib/systemd/system/getty@tty1.service.d/jehon-kiosk-override.conf
scp tmp/node/built/jh-fo.cjs "${target}":/usr/share/jehon/node

ssh "${target}" <<EOS
clear
systemctl daemon-reload

echo "Service: ${service}"

echo "..."; sleep 1s
systemctl restart "${service}"

echo "..."; sleep 5s
journalctl -u "${service}" -n 60

echo "..."; sleep 5s
systemctl status "${service}"
EOS

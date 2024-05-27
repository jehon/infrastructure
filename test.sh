#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

rm -fr tmp/node/built/.built
make tmp/node/built/.built

target=kiosk
service=getty@tty1.service

./deploy-patch-from-packages "${target}" packages/jehon/usr/bin/jh-fo
./deploy-patch-from-packages "${target}" packages/jehon-service-kiosk/usr/sbin/jehon-kiosk-pictures
./deploy-patch-from-packages "${target}" packages/jehon-service-kiosk/usr/lib/systemd/system/getty@tty1.service.d/jehon-kiosk-override.conf
scp tmp/node/built/jh-fo.cjs "${target}":/usr/share/jehon/node

# service=jehon-kiosk.service
# ./deploy-patch-from-packages "${target}" packages/jehon-service-kiosk/usr/lib/systemd/system/jehon-kiosk.service

./deploy-patch-from-packages "${target}" packages/jehon-service-backend/usr/share/jehon-service-backend/docker-compose.yml

# shellcheck disable=SC2087 # client side expension
ssh "${target}" <<EOS
clear
systemctl daemon-reload

echo "Service: ${service}"

echo "..."; sleep 1
systemctl restart "${service}"

echo "..."; sleep 5
journalctl -u "${service}" -n 60

echo "..."; sleep 5
systemctl status "${service}"

echo "..."; sleep 5
ps -e | grep fbi

# Stats
echo "---------- Hardware Stats ------------------"
top -bn1 | head -n 5

EOS

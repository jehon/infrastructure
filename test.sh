#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

rm -fr tmp/node/built/.built
make tmp/node/built/.built

target=kiosk
service=mnt-cloud-musiques.mount

./deploy-patch-from-packages "${target}" \
    packages/jehon/usr/lib/systemd/system/jehon-update-rclone.service \
    packages/jehon/usr/lib/systemd/system/jehon-update-rclone.timer \
    packages/jehon/usr/lib/systemd/system/mnt-cloud-musiques.mount

# ./deploy-patch-from-packages "${target}" \
#     packages/jehon-service-backend/usr/share/jehon-service-backend/docker-compose.yml

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

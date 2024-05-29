#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

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

# echo "..."; sleep 1
# systemctl restart "${service}"

# echo "..."; sleep 5
# systemctl status "${service}"
# journalctl -u "${service}" -n 60

systemctl enable mnt-cloud-musiques.mount
systemctl disable jehon-update-rclone.service
systemctl disable jehon-update-rclone.timer

echo "..."; sleep 2

# Stats
echo "---------- Hardware Stats ------------------"
top -bn1 | head -n 5


# This will always fail
ssh "${host}" reboot || true

EOS

sleep 20s
while true; do
    clear
    echo -n "Testing... "
    ping kiosk -c 1
    ssh kiosk ls /
    sleep 5s
done

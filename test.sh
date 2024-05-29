#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

host=kiosk
service=jehon-cloud@Musiques.service

# ./deploy-patch-from-packages "${host}" \
#     packages/jehon/usr/lib/systemd/system/jehon-update-rclone.service \
#     packages/jehon/usr/lib/systemd/system/jehon-update-rclone.timer \
#     packages/jehon/usr/lib/systemd/system/jehon-cloud@.service \
#     packages/jehon/usr/sbin/jehon-cloud-mount

rsync -r --delete packages/jehon-service-eternal/usr/share/jehon-service-eternal/stack/ \
    ${host}:/usr/share/jehon-service-eternal/stack/

# shellcheck disable=SC2087 # client side expension
ssh "${host}" <<EOS
clear
# systemctl daemon-reload

/usr/sbin/jehon-eternal install

# echo "Service: ${service}"

# echo "..."; sleep 1
# systemctl restart "${service}"

# echo "..."; sleep 5
# systemctl status "${service}"
# journalctl -u "${service}" -n 60

EOS

# # This will always fail
# ssh "${host}" reboot || true

# sleep 20s
# while true; do
#     ping kiosk -c 1 && break || true
# done
# echo "** Ping ok"

# while true; do
#     ssh kiosk "ls /" && break || true
#     sleep 5s
# done
# echo "** SSH ok"

# # shellcheck disable=SC2087 # client side expension
# ssh kiosk <<EOS

# systemctl status systemd-user-sessions.service
# systemctl status "${service}"

# EOS

echo "End of script"

# 1 mount
# 2 service
# 3 timer
# 4 service mount

# 123
# DEE: ok
#
# EDD: ko
# DDDE:

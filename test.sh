#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

. jh-lib

host=dev
service=jehon-cloud@Photos.service

./deploy-patch-from-packages "${host}" \
    packages/jehon/usr/lib/systemd/system/jehon-cloud@.service \
    packages/jehon/usr/sbin/jehon-cloud-mount

# shellcheck disable=SC2087 # client side expension
# ssh "${host}" <<EOS
clear

echo "Service: ${service}"

jh_info "Daemon reload"
sudo systemctl daemon-reload

echo "..."
sleep 1

jh_info "Restarting ${service}"
if ! sudo systemctl restart "${service}"; then
    sudo journalctl -u "${service}" -n 150 -f
fi

echo "..."
sleep 5
jh_info "Status of ${service}"
sudo systemctl status "${service}" | tee

sudo ls -l /mnt/cloud/
sudo ls -l /mnt/cloud/photos
ls -l /mnt/cloud/photos

echo "End of script"
# EOS

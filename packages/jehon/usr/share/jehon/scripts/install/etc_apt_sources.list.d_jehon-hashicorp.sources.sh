#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

target="$(jh-fs "file-to-path" "$0")"
codename="$(lsb_release -cs)"

case "$1" in
"configure" | "")
    (
        cat <<EOS
#
# For Vagrant
#
# Generated by $0
#

X-Repolib-Name: Hashicorp (Jehon)
Types: deb
URIs: https://apt.releases.hashicorp.com
Suites: ${codename}
Components: main
Enabled: yes
Signed-By: /usr/share/keyrings/jehon-hashicorp.gpg
EOS

    ) | jh-install-file "${target}"
    ;;
"remove")
    rm -f "${target}"
    ;;
esac
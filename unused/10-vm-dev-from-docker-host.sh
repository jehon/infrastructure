#!/usr/bin/env bash

set -o errexit

# https://docs.ansible.com/ansible/2.8/dev_guide/developing_inventory.html#developing-inventory

if ! type jh-docker-host-ip &> /dev/null; then
    echo "Warning: no jh-docker-host-ip found - exiting detecting docker host ip"
    echo "{}"
	exit 0
fi

DHIP="$(jh-docker-host-ip)"

if [ -z "$DHIP" ]; then
    echo "No docker host ip for dev" >&2
    echo "{}"
    exit 0
fi

case "$1" in
"--list")
    cat <<-EOF
{
    "all": {
        "hosts": [ "dev" ]
    },
    "_meta": {
        "hostvars": {
            "dev": {
                "ansible_host" : "$DHIP"
            }
        }
    }
}
EOF
    ;;
# "--host")
#     case "$2" in
#     "dev")
#         cat <<-EOF
# {
#     "ansible_host": "$DHIP"
# }
# EOF
# ;;
# *)
#     echo "{}"
#     ;;
# esac
# ;;
*)
    echo "{}"
    ;;
esac

#!/usr/bin/bash

# shellcheck source=SCRIPTDIR/../../../bin/jh-lib
. jh-lib

jh_value "Date"  "$(/usr/bin/date)"
jh_value "IP"    "$(/usr/bin/jh-network-list-ip | awk '{print $2}' | grep -v "127.0.0" | uniq | xargs echo)"

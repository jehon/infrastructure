#!/usr/bin/env bash

if [ "$1" = "" ]; then
    echo "Please specify drive (by path) [1]"
    exit 255
fi

if [ "$2" = "" ]; then
    echo "Please specify space in Gb [2]"
    exit 255
fi

MIN_SPACE="$2"

AVAIL="$(LC_ALL=C df -B 1G --output="avail" "$1" | grep -v "Avail")"
if [ "$AVAIL" -lt "$MIN_SPACE" ]; then
    exit 1
fi

exit 0

#!/usr/bin/env bash

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"

PYTHON="$( dirname "$SWD" )"/tmp/python/common

export PATH="$PYTHON/bin:$PATH"
export PYTHONPATH="$PYTHON:$PYTHONPATH"

#!/usr/bin/env bash

SWD="$(dirname "${BASH_SOURCE[0]}")"

PYTHON="$( dirname "$SWD" )"/.python

export PATH="$PYTHON/bin:$PATH"
export PYTHONPATH="$PYTHON:$PYTHONPATH"

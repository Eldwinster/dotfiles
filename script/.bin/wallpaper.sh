#!/usr/bin/bash

# set -euo pipefail

SCRIPT_NAME="${0##*/}"

usage() {
    cat<<EOF
USAGE:
    $SCRIPT_NAME [OPTIONS] ACTIONS [PATH ...]
EOF
}

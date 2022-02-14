#!/usr/bin/env bash
set -euo pipefail


sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | \
    grep -e '^\s*[[,] ("' \
    -e 'KB_GROUP' | \
    sed -e 's/^\s*//' \
    -e 's/, (/(/' \
    -e 's/\[ (/(/' \
    -e 's/-- KB_GROUP /\n/' \
    -e 's/", /"\t: /' | \
    yad --text-info --back=#282c34 --fore=#46d9ff --geometry=1200x800

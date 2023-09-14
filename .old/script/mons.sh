#!/bin/sh

case ${MONS_NUMBER} in
    1)
        mons -o
        ;;
    2)
        mons --primary LVDS2 -e top
        ;;
    *)
        # Handle it manually
        ;;
esac

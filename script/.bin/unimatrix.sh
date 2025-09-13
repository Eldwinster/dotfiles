#!/bin/sh
# https://unix.stackexchange.com/questions/14879/how-to-inject-keystrokes-via-a-shell-script
(cat ~/.cache/wal/sequences &)
# xdotool key super+F5
slock unimatrix -s 95 -l cgkns
exit

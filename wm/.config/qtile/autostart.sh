#!/bin/sh
# mons --primary LVDS2 -e top || mons --primary LVDS1 -e top
# mons -a -x "$HOME/.bin/mons.sh" & disown
picom &
xbanish &
emacs --daemon &
wallpaper.sh random auto 60m &
setxkbmap us qwerty-fr &

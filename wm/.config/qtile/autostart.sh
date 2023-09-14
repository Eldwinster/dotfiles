#!/bin/bash
# mons --primary LVDS2 -e top || mons --primary LVDS1 -e top
picom &
xbanish &
# mons -a -x "$HOME/.bin/mons.sh" & disown
emacs --daemon &
wallpaper.sh random auto 120m &
setxkbmap us qwerty-fr &
# mons --pr

#!/bin/bash
picom &
xbanish &
setxkbmap us qwerty-fr &
mons -a -x "$HOME/.bin/mons.sh" & disown
emacs --daemon &
wallpaper.sh random auto 120m &

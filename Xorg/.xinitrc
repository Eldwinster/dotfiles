#!/bin/sh
# Load ressources

xrdb -merge .Xressources

# exec $HOME/.config/polybar/polybar-restart &
# exec wallpaper.sh random &
# exec python3 ~/.scripts/inkscape-shortcut-manager/main.py &
# exec setxkbmap us qwerty-fr &
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
xset s off -dpms
exec xmonad

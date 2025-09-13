# [[file:xorg.org::*Xinitrc][Xinitrc:1]]
#!/bin/sh
# Load ressources

xrdb -merge .Xressources

# exec $HOME/.config/polybar/polybar-restart &
# exec wallpaper.sh random &
# exec python3 ~/.scripts/inkscape-shortcut-manager/main.py &
# exec setxkbmap us qwerty-fr &
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
# sinon quand c'est sur batterie le pc se met en veille...
xset dpms 0 0 0
xset s off -dpms
exec qtile start
# Xinitrc:1 ends here

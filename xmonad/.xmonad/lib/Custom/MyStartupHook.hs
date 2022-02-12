module Custom.MyStartupHook where

import XMonad
import XMonad.Util.SpawnOnce

myStartupHook :: X ()
myStartupHook = do
        spawnOnce "picom &"
        spawnOnce "xbanish &"
        spawnOnce "clight &"
        spawnOnce "inkscape-figures watch"
        spawnOnce "python3 ~/.scripts/inkscape-shortcut-manager/main.py &"
        spawnOnce "setxkbmap us qwerty-fr &"
        spawnOnce "wallpaper.sh random auto 30m &"
        spawn "$HOME/.config/polybar/polybar-restart"

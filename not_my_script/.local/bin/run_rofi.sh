#!/usr/bin/env bash
options="one
two
three
four
five
six
seven
eight
nine
ten
eleven
twelve
thirtheen
fourteen
fifteen"
theme=${1:-$HOME/.config/rofi/config.rasi}
selection=$(echo -e "${options}" | rofi -dmenu -normal-window -config $theme)
case "${selection}" in
  "one")
    notify-send "run_rofi.sh" "one";;
  "two")
    notify-send "run_rofi.sh" "two";;
  "three")
    notify-send "run_rofi.sh" "three";;
  "four")
    notify-send "run_rofi.sh" "four";;
  "five")
    notify-send "run_rofi.sh" "five";;
  "six")
    notify-send "run_rofi.sh" "six";;
  "seven")
    notify-send "run_rofi.sh" "seven";;
  "eight")
    notify-send "run_rofi.sh" "eight";;
  "nine")
    notify-send "run_rofi.sh" "nine";;
  "ten")
    notify-send "run_rofi.sh" "ten";;
  "eleven")
    notify-send "run_rofi.sh" "eleven";;
  "twelve")
    notify-send "run_rofi.sh" "twelve";;
  "thirteen")
    notify-send "run_rofi.sh" "thirtheen";;
  "fourteen")
    notify-send "run_rofi.sh" "fourteen";;
  "fifteen")
    notify-send "run_rofi.sh" "fifteen";;
esac

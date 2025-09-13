#!/bin/bash
# TODO rewrite it
# TODO sudo it in autostart.sh and make -C $HOME/github/st/ clean intall to change st's colorscheme
arg1=$1
arg2=$2
if [ -z $3 ]; then
  arg3=1m
elif [[ $3 =~ ^[0-9]{,3}[s,m,h] ]]; then
  arg3=$3
else
  echo -e "\e[31mError: '$3' is not a number between 0 and 999 with suffix: s (second), m (minute) or h (hour)\e[0m"
  exit 1
fi

gifsleep=0.1

time=$(date +%H)
morning=6
noon=12
night=18

walpath=$HOME/.cache/wal/wal
wallPath=$HOME/.wallpaper
gifPath=$HOME/Pictures/Wallpapers/gifs-frames
morningWall=$wallPath/alena-aenami-girl-window.jpg
noonWall=$wallPath/taehoon-kang-16.jpg
nightWall=$wallPath/alena-aenami-far-from-tomorrow.jpg
bingWall=$HOME/.bing-daily/bing-daily.jpg

preset() {
  if [ $time -ge $night -o $time -lt $morning ]; then
    wal -n -i $nightWall
    feh --bg-tile "$(< "$walpath")"
  elif [ $time -ge $noon ]; then
    wal -n -i $noonWall
    feh --bg-tile "$(< "$walpath")"
  elif [ $time -ge $morning ]; then
    wal -n -i $morningWall
    feh --bg-tile "$(< "$walpath")"
  fi
}

# if feh does not apply wallpaper add "DISPAY=:0" before feh (may be needed with a cronjob)
random() {
    wal -s -n -i $wallPath
    feh --bg-fill "$(< "$walpath")"
    pywalfox update
    qtile cmd-obj -o cmd -f reload_config
}

presetgif() {
  while :; do
    for image in $gifPath/rainy-day/*; do
      feh --bg-tile $image
      sleep $gifsleep
    done
  done
}

randomgif() {
  cdir=$(ls $gifPath | wc -l)
  rnum=$(shuf -i 1-$cdir -n 1)
  rdir=$(ls $gifPath | sed -n $rnum"p")
  while :; do
    for image in $gifPath/$rdir/*; do
      feh --bg-tile $image
      sleep $gifsleep
    done
  done
}

bingdaily() {
  python3 /home/$USER/Projects/fun/bing-daily/bing-daily.py
  feh --bg-tile $bingWall
}

auto() {
  while :; do
    $arg1
    sleep $arg3
  done
}

verify() {
  if [ "$arg2" = "auto" ]; then
    auto
  elif [ "$arg2" = "" ]; then
    echo
  else
    usage
    exit 1
  fi
}

usage() {
  echo -e "usage: $0 COMMAND [OPTION] [TIME TO SLEEP - if not passed, default time will be used (only for preset and random commands)]\n"
  echo -e """Examples:
    $0 bingdaily
    $0 bingdaily auto 59s
    $0 preset
    $0 preset auto 5m
    $0 random auto
    $0 random auto 1h
    $0 presetgif
    $0 randomgif
  """
  echo -e "List of Commands:"
  echo -e "bingdaily  - download daily wallpaper from bing and set as your wallpaper"
  echo -e "preset     - change presetted wallpaper based on the time of the day"
  echo -e "random     - change to a random wallpaper"
  echo -e "presetgif  - change wallpaper to a presetted gif"
  echo -e "randomgif  - change wallpaper to a random gif"
  echo
  echo -e "List of Options:"
  echo -e "auto       - change wallpaper automatically"
  exit 1
}

case $1 in
bingdaily)
  verify
  bingdaily
  ;;
preset)
  verify
  preset
  ;;
random)
  verify
  random
  ;;
presetgif)
  presetgif
  ;;
randomgif)
  randomgif
  ;;
*)
  usage
  ;;
esac

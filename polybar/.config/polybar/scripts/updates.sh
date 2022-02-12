#!/bin/sh
pacman=$(pacman -Qqu 2>/dev/null | wc -l)
aur=$(pikaur -Qaqu 2>/dev/null | wc -l)
out=""
out="${out}P: ${pacman} "
out="${out}A: ${aur} "
echo "${out%?}"

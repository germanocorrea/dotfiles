#!/bin/bash
# swaybg -i '/home/gege/dotfiles/current_bg.jpg' -o '*' -m fill
for (( ; ; )); do
    for file in wallpapers/*.*; do
        timeout 120 swaybg -i $file -o '*' -m fill
    done
done

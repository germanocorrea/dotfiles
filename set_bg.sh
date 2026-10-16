#!/bin/sh
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval. Code from https://codeberg.org/LGFae/awww/src/branch/main/example_scripts/awww_randomize.sh

DEFAULT_INTERVAL=300 # In seconds

awww kill || true
awww-daemon &

# See awww-img(1)
RESIZE_TYPE="crop"
export AWWW_TRANSITION_FPS="120"
export AWWW_TRANSITION_STEP="2"

while true; do
    find "$HOME/dotfiles/wallpapers/" -type f |
        while read -r img; do
            echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
        done |
        sort -n | cut -d':' -f2- |
        while read -r img; do
            awww img --resize="$RESIZE_TYPE" "$img" --transition-type wipe --transition-step 90 --transition-angle 30
            sleep "$DEFAULT_INTERVAL"
        done
done

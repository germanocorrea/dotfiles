#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <image-file>" >&2
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: file not found: $1" >&2
    exit 1
fi

swaybg -i "$1" -o '*' -m fill

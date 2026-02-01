#!/bin/bash

NAME="$1"
REL_PATH="$2"

if [ -z "$NAME" ] || [ -z "$REL_PATH" ]; then
    echo "Usage: $0 <name> <path/of/config>"
    exit 1
fi

SOURCE="$HOME/$REL_PATH"
DEST_PARENT="$NAME/$(dirname "$REL_PATH")"

if [ ! -e "$SOURCE" ]; then
    echo "Error: Source path '$SOURCE' not found."
    exit 1
fi

mkdir -p "$DEST_PARENT"
cp -r "$SOURCE" "$DEST_PARENT"

echo "Successfully copied '$SOURCE' to '$PWD/$DEST_PARENT'"

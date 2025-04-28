#!/bin/sh
IMAGE_DIR="$HOME/Pictures/BingWallpapers" 

# find a random img
selected_image=$(ls -1 "$IMAGE_DIR"/*.jpg 2>/dev/null | shuf -n 1)

# lock 
swaylock -F -e -f -i $selected_image

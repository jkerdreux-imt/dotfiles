#!/bin/bash

# Directory to store wallpapers
WALLPAPER_DIR="$HOME/Pictures/BingWallpapers"
mkdir -p "$WALLPAPER_DIR"

# Today's filename (based on date)
FILENAME="$WALLPAPER_DIR/bing_$(date +%Y-%m-%d).jpg"

# Function to set wallpaper (supports swww or hyprpaper)
set_wallpaper() {
    local file="$1"
    if command -v swww &> /dev/null; then
        swww img "$file"
    elif command -v hyprctl &> /dev/null; then
        hyprctl hyprpaper preload "$file"
        hyprctl hyprpaper wallpaper ",$file"
    elif command -v feh &> /dev/null; then
        feh --bg-fill "$file"
    else
        echo "No supported wallpaper setter found (swww, hyprpaper, feh)."
        exit 1
    fi
}

# If -r is passed, pick a random wallpaper from WALLPAPER_DIR
if [ "$1" == "-r" ]; then
    if [ -z "$(ls -A "$WALLPAPER_DIR")" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    RANDOM_FILE=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    echo "Random wallpaper: $RANDOM_FILE"
    set_wallpaper "$RANDOM_FILE"
    exit 0
fi

# Otherwise: fetch today's Bing wallpaper
BING_JSON=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
BING_URL="https://www.bing.com$(echo "$BING_JSON" | jq -r '.images[0].url')"

if [ -z "$BING_URL" ]; then
    echo "Error: Could not retrieve Bing wallpaper URL"
    exit 1
fi

# Download if not already existing
if [ ! -f "$FILENAME" ]; then
    curl -s -o "$FILENAME" "$BING_URL"
    echo "New wallpaper downloaded: $FILENAME"
else
    echo "Wallpaper already exists: $FILENAME"
fi

set_wallpaper "$FILENAME"

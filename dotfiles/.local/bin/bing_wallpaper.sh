#!/bin/bash

# Dossier où stocker les fonds d'écran
WALLPAPER_DIR="$HOME/Pictures/BingWallpapers"
mkdir -p "$WALLPAPER_DIR"

# Récupérer l'URL du fond d'écran Bing
BING_JSON=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
BING_URL="https://www.bing.com$(echo "$BING_JSON" | jq -r '.images[0].url' | sed 's/\&/&/g')"

# Nom du fichier basé sur la date
FILENAME="$WALLPAPER_DIR/bing_$(date +%Y-%m-%d).jpg"

echo "New wallpaper: $FILENAME"

# Télécharger l'image si elle n'existe pas encore
if [ ! -f "$FILENAME" ]; then
    curl -s -o "$FILENAME" "$BING_URL"
fi

# Appliquer comme fond d'écran (choisir la commande selon ton setup)
swww img "$FILENAME"  # Pour `swww`
# feh --bg-fill "$FILENAME"  # Pour `feh`
# hyprctl hyprpaper preload "$FILENAME" && hyprctl hyprpaper wallpaper "eDP-1,$FILENAME"  # Pour `hyprpaper`

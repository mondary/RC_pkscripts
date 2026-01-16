#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Change Wallpaper
# @raycast.keyword wallpaper
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName ./ChangeWallpaper

# Documentation:
# @raycast.description Change Wallpaper
# @raycast.author Cmondary
# @raycast.authorURL https://github.com/mondary

# Liste des fichiers d'images dans le dossier wallpapers
image_files=(wallpapers/*.jpg)

change_wallpaper() {
    if [ ${#image_files[@]} -eq 0 ]; then
        echo "Aucune image .jpg trouvée dans ./wallpapers"
        return 1
    fi

    local random_image
    random_image="${image_files[RANDOM % ${#image_files[@]}]}"
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$PWD/$random_image\""
}

if [ "$1" = "--once" ]; then
    change_wallpaper
    exit $?
fi

# Définir le fond d'écran sur tous les écrans à partir d'une image aléatoire toutes les 60 secondes
while true; do
    change_wallpaper
    sleep 60
done

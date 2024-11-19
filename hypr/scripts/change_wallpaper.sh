#!/bin/bash

# Path to your wallpaper directory
WALLPAPER_DIR=~/Pictures/Knight

# Start the swww daemon if it's not running
swww query || { swww init && sleep 1; }

# Select a random wallpaper from the directory (only .jpg and .png files)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# Check if a wallpaper was found
if [ -n "$WALLPAPER" ]; then
    # Use swww to set the wallpaper with a transition
    swww img "$WALLPAPER" --transition-type any --transition-step 60

    # Apply the new wallpaper's colors using Pywal
    wal -i "$WALLPAPER"  && pywalfox update && pywal-discord && walogram -i "$WALLPAPER"
    # Reload Waybar to apply the new colors
    ~/.config/waybar/scripts/reload_waybar.sh
else
    echo "No wallpapers found in $WALLPAPER_DIR"
fi

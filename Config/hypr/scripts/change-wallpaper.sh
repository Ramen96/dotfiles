#!/bin/bash
# Preload a new wallpaper
hyprctl hyprpaper preload "~/.config/wallpapers/mountains.jpg"
# Set it to monitor (e.g., eDP-1)
hyprctl hyprpaper wallpaper "DP-6, ~/.config/wallpapers/mountains.jpg"
# Unload unused images to save RAM
hyprctl hyprpaper unload unused

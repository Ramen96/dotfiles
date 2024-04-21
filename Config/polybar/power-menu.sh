#!/bin/bash

# Path to your config.rasi file
CONFIG_FILE="/home/eric/.config/rofi/config.rasi"

# Define options
options="Shutdown\nRestart\nLogout"

# Get user selection
selected=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -lines 3 -width 20 -theme "$CONFIG_FILE")

# Handle selected option
case "$selected" in
    "Shutdown")
        systemctl poweroff
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Logout")
        pkill -KILL -u $USER
        ;;
    *)
        echo "Invalid option selected"
        ;;
esac

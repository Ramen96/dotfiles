#!/bin/bash

# Check if picom is running
if pgrep -x "picom" > /dev/null
then
    # If picom is running, kill it
    killall picom
    notify-send "Picom stopped"
else
    # If picom is not running, start it
    picom --config ~/.config/picom/picom.conf &
    notify-send "Picom started"
fi

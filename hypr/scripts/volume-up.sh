#!/bin/bash
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1 | tr -d '%')
if [ "$current_volume" -lt 100 ]; then
  pactl set-sink-volume @DEFAULT_SINK@ +5%
fi

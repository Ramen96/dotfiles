#!/bin/bash

# Get volume using wpctl
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

if [[ "$vol_raw" == "1.00" ]]; then
  volume=100
else
  volume=$(echo "$vol_raw" | sed 's/0\.//' | sed 's/^0//')
  volume=${volume:-0}
  [[ ${#volume} -eq 1 ]] && [[ "$vol_raw" == *"."* ]] && volume=$((volume * 10))
fi

# Handle mute
if [[ $(wpctl get-volume @DEFAULT_AUDIO_SINK@) == *"[MUTED]"* ]]; then
  echo "<span color='#6c7086'>MUTED</span>"
  exit
fi

# Config
bar_size=10
# #00e6b8 + aa (alpha/transparency)
color_active="#00e6b8aa"
color_dim="#313244"

num_active=$(((volume + 5) / 10))
((num_active > bar_size)) && num_active=$bar_size
num_dim=$((bar_size - num_active))

active_bar=""
dim_bar=""

for ((i = 0; i < num_active; i++)); do active_bar+="▓"; done
for ((i = 0; i < num_dim; i++)); do dim_bar+="▓"; done

echo "<span color='$color_active'>$active_bar</span><span color='$color_dim'>$dim_bar</span>"

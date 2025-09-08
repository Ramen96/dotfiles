#!/bin/bash

# Function to get volume
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | sed 's/%//'
}

# Function to get brightness
get_brightness() {
    brightness=$(brightnessctl get 2>/dev/null || echo 50)
    max=$(brightnessctl max 2>/dev/null || echo 100)
    percent=$(echo "scale=0; $brightness * 100 / $max" | bc 2>/dev/null || echo 50)
    echo $percent
}

# Function to get CPU usage
get_cpu_usage() {
    # Get initial values
    read -r cpu1 < <(grep 'cpu ' /proc/stat)
    sleep 0.2
    # Get final values
    read -r cpu2 < <(grep 'cpu ' /proc/stat)

    # Calculate usage
    cpu1_array=($cpu1)
    cpu2_array=($cpu2)

    cpu1_idle="${cpu1_array[4]}"
    cpu1_total=$((${cpu1_array[1]} + ${cpu1_array[2]} + ${cpu1_array[3]} + ${cpu1_array[4]} + ${cpu1_array[5]} + ${cpu1_array[6]} + ${cpu1_array[7]} + ${cpu1_array[8]}))
    cpu2_idle="${cpu2_array[4]}"
    cpu2_total=$((${cpu2_array[1]} + ${cpu2_array[2]} + ${cpu2_array[3]} + ${cpu2_array[4]} + ${cpu2_array[5]} + ${cpu2_array[6]} + ${cpu2_array[7]} + ${cpu2_array[8]}))

    idle_diff=$((cpu2_idle - cpu1_idle))
    total_diff=$((cpu2_total - cpu1_total))

    if [ "$total_diff" -gt 0 ]; then
        usage=$(( (total_diff - idle_diff) * 100 / total_diff ))
        echo "$usage"
    else
        echo "0"
    fi
}

# Function to get memory usage
get_memory_usage() {
    free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100.0}'
}

# Combine and print the output
volume_percent=$(get_volume)
brightness_percent=$(get_brightness)
cpu_percent=$(get_cpu_usage)
mem_percent=$(get_memory_usage)

# Print the final formatted string
# Note: The 'format' in the config is "{} {} {} {}"
# So we print the volume, brightness, cpu, and memory in that order
echo "󰕾 ${volume_percent}% 󰃠 ${brightness_percent}% 󰘚 ${cpu_percent}% 󰍛 ${mem_percent}%"

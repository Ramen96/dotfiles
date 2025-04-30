#!/bin/bash

LOW_THRESHOLD=20
CRITICAL_THRESHOLD=10

PREV_STATUS="Unknown"

while true; do
    # Get battery percentage and status
    BATTERY_LEVEL=$(acpi -b | grep -oP '[0-9]+(?=%)')
    BATTERY_STATUS=$(acpi -b | grep -oP 'Charging|Discharging')

    if [ "$BATTERY_STATUS" = "Charging" ] && [ "$PREV_STATUS" != "Charging" ]; then
        swaync-client -s "notify-send 'Charging Started' 'Battery is now charging at ${BATTERY_LEVEL}%.'"
    fi

    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_THRESHOLD" ]; then
            swaync-client -s "notify-send -u critical 'Critical Battery Warning' 'Battery is at ${BATTERY_LEVEL}%! Charge immediately!'"
        elif [ "$BATTERY_LEVEL" -le "$LOW_THRESHOLD" ]; then
            swaync-client -s "notify-send 'Low Battery Warning' 'Battery is at ${BATTERY_LEVEL}%! Please charge soon.'"
        fi
    fi

    PREV_STATUS="$BATTERY_STATUS"

    sleep 60
done

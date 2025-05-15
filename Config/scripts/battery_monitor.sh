#!/bin/bash

# Set battery thresholds
LOW_THRESHOLD=20
CRITICAL_THRESHOLD=10

# Variable to track charging state
PREV_STATUS="Unknown"

# Infinite loop to check battery periodically
while true; do
  # Get battery percentage and status
  BATTERY_LEVEL=$(acpi -b | grep -oP '[0-9]+(?=%)')
  BATTERY_STATUS=$(acpi -b | grep -oP 'Charging|Discharging')

  # Debugging output (remove later if not needed)
  echo "Battery Level: $BATTERY_LEVEL%, Status: $BATTERY_STATUS, Prev Status: $PREV_STATUS"

  # Check if status changed to Charging
  if [ "$BATTERY_STATUS" = "Charging" ] && [ "$PREV_STATUS" != "Charging" ]; then
    notify-send "Charging Started" "Battery is now charging at ${BATTERY_LEVEL}%."
  fi

  # Check battery levels when discharging
  if [ "$BATTERY_STATUS" = "Discharging" ]; then
    if [ "$BATTERY_LEVEL" -le "$CRITICAL_THRESHOLD" ]; then
      notify-send -u critical "Critical Battery Warning" "Battery is at ${BATTERY_LEVEL}%! Charge immediately!"
    elif [ "$BATTERY_LEVEL" -le "$LOW_THRESHOLD" ]; then
      notify-send "Low Battery Warning" "Battery is at ${BATTERY_LEVEL}%! Please charge soon."
    fi
  fi

  # Update previous status
  PREV_STATUS="$BATTERY_STATUS"

  # Sleep for 15 seconds
  sleep 15
done

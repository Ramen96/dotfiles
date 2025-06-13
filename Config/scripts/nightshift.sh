#!/bin/bash

if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
  wlsunset -t 3000 -T 4000 &
else
  pkill -x wlsunset
fi

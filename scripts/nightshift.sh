#!/bin/bash

if pgrep -x "wlsunset" >/dev/null; then
  pkill -x wlsunset
else
  # setsid runs the program in a new session so it survives the script exit
  setsid wlsunset -t 3700 -T 4100 >/dev/null 2>&1 &
fi

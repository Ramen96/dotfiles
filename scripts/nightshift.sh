#!/bin/bash

if pgrep -x wlsunset >/dev/null; then
  # wlsunset is running → kill it
  pkill -x wlsunset
else
  # wlsunset is not running → start it
  wlsunset -t 3000 -T 3400 &
fi

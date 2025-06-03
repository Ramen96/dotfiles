#!/bin/bash

if pgrep wlsunset > /dev/null; then
    kill $(pgrep wlsunset)
else
    wlsunset -t 3000 -T 4000 &
fi

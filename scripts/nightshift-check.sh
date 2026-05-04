#!/bin/bash
if pgrep -x "wlsunset" >/dev/null; then
  printf "true"
else
  printf "false"
fi

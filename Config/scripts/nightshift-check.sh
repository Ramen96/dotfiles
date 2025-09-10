#!/bin/sh
if pgrep -x "wlsunset" >/dev/null; then
  echo "true"
else
  echo "false"
fi

#!/bin/bash

# Check wlsunset status for swaync toggle
[[ $(pgrep -x wlsunset) ]] && echo true || echo false

#!/bin/bash
[[ $(bluetoothctl show | grep "Powered: yes") ]] && printf "true" || printf "false"
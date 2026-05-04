#!/bin/bash
[[ $(bluetoothctl show | grep "Powered: yes") ]] && bluetoothctl power off || bluetoothctl power on
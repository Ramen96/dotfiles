#!/bin/bash
[[ $(nmcli radio wifi) == "enabled" ]] && printf "true" || printf "false"
#!/bin/bash
[[ $(nmcli radio wifi) == "enabled" ]] && nmcli radio wifi off || nmcli radio wifi on
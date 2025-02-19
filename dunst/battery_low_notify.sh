#!/bin/bash

THRESHOLD=15
last_notification=0

while true; do
    battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)' | head -n1)
    if [ $battery_level -le $THRESHOLD ] && [ $last_notification -eq 0 ]; then
        notify-send -a Battery -u critical "Battery Low"
        last_notification=1
    elif [ $battery_level -gt $THRESHOLD ] && [ $last_notification -eq 1 ]; then
        last_notification=0
    fi
    sleep 10
done


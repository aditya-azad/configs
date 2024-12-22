#!/bin/bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

previous_status=""

while true; do
    charger_status=$(cat /sys/class/power_supply/AC0/online)
    
    if [ "$charger_status" != "$previous_status" ]; then
        if [ "$charger_status" -eq 1 ]; then
            dunstify -a Charger "Connected"
            aplay ~/code/configs/dunst/power-plug.wav
        else
            dunstify -a Charger "Disconnected"
            aplay ~/code/configs/dunst/power-unplug.wav
        fi
        previous_status="$charger_status"
    fi
    sleep 1
done

#!/bin/sh

ACPI_RES=$(acpi -b)
ACPI_CODE=$?
if [ $ACPI_CODE -eq 0 ]
then
    BAT_LEVEL_ALL=$(echo "$ACPI_RES" | grep -v "unavailable" | grep -E -o "[0-9][0-9]?[0-9]?%")
    BAT_LEVEL=$(echo "$BAT_LEVEL_ALL" | awk -F"%" 'BEGIN{tot=0;i=0} {i++; tot+=$1} END{printf("%d%%\n", tot/i)}')
    TIME_LEFT=$(echo "$ACPI_RES" | grep -v "unavailable" | grep -E -o "[0-9]{2}:[0-9]{2}:[0-9]{2}")
    IS_CHARGING=$(echo "$ACPI_RES" | awk '/Battery 0:/ {print ($3 != "Discharging,")}')

    if [ "$IS_CHARGING" -eq 0 ]
    then
        echo " 󰁹  $BAT_LEVEL"
    else
        echo " 󰂅  $BAT_LEVEL"
    fi
else
    echo "BAT FAILED"
fi

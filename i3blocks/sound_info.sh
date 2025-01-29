#!/bin/sh

VOLUME_MUTE="  "
VOLUME_LOW="  "
VOLUME_MID="  "
VOLUME_HIGH="  "

# Get the volume and mute status using pactl
SINK_INFO=$(pactl get-sink-volume @DEFAULT_SINK@)
SOUND_LEVEL=$(echo "$SINK_INFO" | awk '{print $5}' | tr -d '%')
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

case $BLOCK_BUTTON in
    1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

# Determine the icon based on volume level and mute status
if [ "$MUTED" = "yes" ]; then
    ICON="$VOLUME_MUTE"
else
    if [ "$SOUND_LEVEL" -lt 34 ]; then
        ICON="$VOLUME_LOW"
    elif [ "$SOUND_LEVEL" -lt 67 ]; then
        ICON="$VOLUME_MID"
    else
        ICON="$VOLUME_HIGH"
    fi
fi

# Output the result
echo "$ICON" "$SOUND_LEVEL" | awk '{ printf(" %s %3s%% \n", $1, $2) }'

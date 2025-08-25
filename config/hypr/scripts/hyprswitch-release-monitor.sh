#!/bin/bash

# Run libinput debug-events and capture the output
libinput debug-events | while read -r line; do
    # Example: Check for key press events
    if [[ "$line" =~ "KEYBOARD_KEY" ]]; then
        if [[ "$line" =~ "released" ]]; then
            if [[ "$line" =~ "KEY_LEFTMETA" || "$line" =~ "KEY_RIGHTMETA" ]]; then
                hyprswitch close
                hyprctl dispatch submap reset
            fi
        fi
    fi
done

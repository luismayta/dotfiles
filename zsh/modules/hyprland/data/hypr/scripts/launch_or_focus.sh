#!/bin/bash

# Focus existing window if found, otherwise launch
# Usage: launch_or_focus.sh [--class CLASS] <command...>

if [ "$1" = "--class" ]; then
    window_class="$2"
    shift 2
else
    window_class="$1"
fi

fallback_cmd="$@"

window_class_lower=$(echo "$window_class" | tr '[:upper:]' '[:lower:]')

if hyprctl clients -j | jq -e --arg cls "$window_class_lower" '[.[] | select(.class | ascii_downcase == $cls and .workspace.id != -1)] | length > 0' > /dev/null 2>&1; then
    hyprctl dispatch focuswindow "$window_class"
else
    $fallback_cmd
fi

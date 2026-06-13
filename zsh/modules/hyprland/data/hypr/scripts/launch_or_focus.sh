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

address=$(hyprctl clients -j | jq -r --arg cls "$window_class_lower" \
  '[.[] | select(.class | ascii_downcase == $cls) | .address][0] // empty')

if [ -n "$address" ]; then
    hyprctl dispatch focuswindow "address:$address"
else
    $fallback_cmd
fi

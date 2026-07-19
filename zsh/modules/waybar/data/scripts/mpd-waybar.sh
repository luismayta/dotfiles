#!/bin/bash

# MPD waybar module — scrolling song title with play/pause/stop icons
# Event-driven via mpc idle (near-zero CPU when idle)

echo "Music Off"

WIDTH=25
MODULE_WIDTH=29

PREFIX_PLAY=" | "
PREFIX_PAUSE=" | "
PREFIX_STOP=" | "
STOP_TEXT="Music Off"

WIDTH_PLAY=$((WIDTH + ${#PREFIX_PLAY}))
WIDTH_PAUSE=$((WIDTH + ${#PREFIX_PAUSE}))
WIDTH_STOP=$((WIDTH + ${#PREFIX_STOP}))

animation() {
    local current_song="$1"
    local prefix="$2"
    local idle_pid="$3"
    local total_width="$4"

    slice_loop() {
        local str="$1"
        local start=$2
        local how_many=$3
        local len=${#str}
        local result=""
        for ((i=0; i < how_many; i++)); do
            local index=$(((start + i) % len))
            local char="${str:index:1}"
            result="${result}${char}"
        done
        echo -n "$result"
    }

    msg="${current_song} "
    begin=0

    while kill -0 "$idle_pid" 2>/dev/null; do
        slice=$(slice_loop "$msg" "$begin" "$WIDTH")
        printf "%-${MODULE_WIDTH}s\n" "${prefix}${slice}"
        sleep 0.30
        ((begin = begin + 1))
    done
}

current_status() {
    get_status=$(mpc status)
    mpc_status_lines=$(echo "$get_status" | wc -l)
    mpc_second_line=$(echo "$get_status" | sed -n '2 p')
    mpc_status=""

    if [ "$mpc_status_lines" -eq 1 ]; then
        mpc_status="stopped"
    fi

    if [ "$mpc_status_lines" -eq 3 ]; then
        if [[ $mpc_second_line == *"[playing]"* ]]; then
            mpc_status="playing"
        fi
        if [[ $mpc_second_line == *"[paused]"* ]]; then
            mpc_status="paused"
        fi
    fi
    echo "$mpc_status"
}

while true; do
    mpc idle player >/dev/null &
    idle_pid=$!

    status=$(current_status)

    case "$status" in
        "playing")
            current_song=$(mpc current)
            current_song=${current_song//&/and}
            current_song=${current_song//</}
            current_song=${current_song//>/}
            animation "$current_song" "${PREFIX_PLAY}" "$idle_pid" "${WIDTH_PLAY}"
            ;;
        "paused")
            current_song=$(mpc current)
            current_song=${current_song//&/and}
            current_song=${current_song//</}
            current_song=${current_song//>/}
            animation "$current_song" "${PREFIX_PAUSE}" "$idle_pid" "${WIDTH_PAUSE}"
            ;;
        "stopped")
            printf "%s%s\n" "${PREFIX_STOP}" "${STOP_TEXT}"
            wait $idle_pid
            ;;
        *)
            echo "Error: check mpc full status."
            wait $idle_pid
            ;;
    esac
done

#!/bin/bash

# MPD waybar heart icon — shows if current song is in favorites playlist
# Event-driven via mpc idle (near-zero CPU when idle)

# Load config (PLAYLIST_NAME and future settings)
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=mpd.conf
source "${SCRIPT_PATH}/mpd.conf"

while true; do
    current_song=$(mpc --format %file% current)

    if [[ -n "$current_song" ]]; then
        if mpc --format %file% playlist "$PLAYLIST_NAME" | grep -Fxq "$current_song"; then
            printf " \n"
        else
            printf " \n"
        fi
    else
        printf "\n"
    fi

    mpc idle player playlist stored_playlist >/dev/null
done

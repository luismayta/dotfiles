#!/bin/bash

# MPD waybar heart toggle — add/remove current song from favorites playlist
# Runs on-click (one-shot, not long-running)

# Load config (PLAYLIST_NAME and future settings)
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=mpd.conf
source "${SCRIPT_PATH}/mpd.conf"

song=$(mpc --format %file% current)
[[ -z "$song" ]] && exit 0

pos=$(mpc --format %file% playlist "$PLAYLIST_NAME" | grep -nFx "$song" | cut -d: -f1)

if [[ -n "$pos" ]]; then
    mpc delplaylist "$PLAYLIST_NAME" "$pos"
else
    mpc addplaylist "$PLAYLIST_NAME" "$song"
fi

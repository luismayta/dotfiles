# shellcheck shell=bash

function editalacritty {
    message_info "Editing alacritty configuration"
    "${EDITOR}" "${ALACRITTY_FILE_SETTINGS}"
}
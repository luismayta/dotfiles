# shellcheck shell=bash

function editwezterm {
    message_info "Editing wezterm configuration"
    "${EDITOR}" "${WEZTERM_PATH}"
}

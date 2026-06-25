# shellcheck shell=bash

function editghostty {
    message_info "Editing ghostty configuration"
    "${EDITOR}" "${GHOSTTY_PATH}"
}

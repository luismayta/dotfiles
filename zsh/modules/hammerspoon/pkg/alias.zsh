# shellcheck shell=bash

function edithammerspoon {
    message_info "Editing hammerspoon configuration"
    "${EDITOR}" "${HAMMERSPOON_PATH}"
}

# shellcheck shell=bash

if core::exists assh; then alias ssh="assh wrapper ssh"; fi

function editassh {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    "${EDITOR}" "${ASSH_FILE_SETTINGS}"
}

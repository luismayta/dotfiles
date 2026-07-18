# shellcheck shell=bash

function editopencode {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${AI_OPENCODE_CONFIG_FILE_PATH}"
}

function ai::opencode::install {
    ai::internal::opencode::install
}

function ai::opencode::sync {
    ai::internal::opencode::sync
}

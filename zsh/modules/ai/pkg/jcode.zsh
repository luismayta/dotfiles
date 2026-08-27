# shellcheck shell=bash

function editjcode {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${ZSH_AI_JCODE_CONFIG_PATH}"
}

function ai::jcode::install {
    ai::internal::jcode::install
}

function ai::jcode::sync {
    ai::internal::jcode::sync
}

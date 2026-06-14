# shellcheck shell=bash

function editrc {
    if [ -z "${1}" ]; then
        "${EDITOR}" "${HOME}"/.zshrc
        return
    fi
    "${EDITOR}" "${DOTFILES_CORE_PATH}"/"${1}".zsh
}

function editprivaterc {
    if [ -z "${PRIVATERC}" ]; then
        message_info "not exist file privaterc"
        return
    fi
    "${EDITOR}" "${PRIVATERC}"
}

function editcustomrc {
    if [ -z "${CUSTOMRC}" ]; then
        message_info "not exist file customrc"
        return
    fi
    "${EDITOR}" "${CUSTOMRC}"
}

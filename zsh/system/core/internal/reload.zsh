# shellcheck shell=bash

function core::reload {
    if [[ "${OSTYPE}" == darwin* ]]; then
        exec "${SHELL}" -l
    else
        exec "${SHELL}"
    fi
}

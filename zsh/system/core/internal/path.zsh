# shellcheck shell=bash

function core::path::append {
    [ -e "${1}" ] && export PATH="${PATH}:${1}"
}

function core::path::prepend {
    [ -e "${1}" ] && export PATH="${1}:${PATH}"
}

function core::path::clean {
    echo "${1}" | tr ':' '\n' | uniq | xargs | tr ' ' ':'
}

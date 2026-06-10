# shellcheck shell=bash

function path::append {
    [ -e "${1}" ] && export PATH="${PATH}:${1}"
}

function path::prepend {
    [ -e "${1}" ] && export PATH="${1}:${PATH}"
}

function path::clean {
    echo "${1}" | tr ':' '\n' | uniq | xargs | tr ' ' ':'
}

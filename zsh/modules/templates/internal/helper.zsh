# shellcheck shell=bash

function templates::internal::list {
    find "${TEMPLATES_TEMPLATES_PATH}" -type f | sed "s|${TEMPLATES_TEMPLATES_PATH}/||"
}

function templates::internal::find {
    local query="${1}"
    templates::internal::list | fzf --query="${query}"
}

function templates::internal::read {
    local template_path="${1}"
    cat "${TEMPLATES_TEMPLATES_PATH}/${template_path}"
}

function templates::internal::load {
    local template_path
    template_path=$(templates::internal::find "${1}")
    if [[ -n "${template_path}" ]]; then
        templates::internal::read "${template_path}"
    fi
}

# shellcheck shell=bash

function templates::run {
    local template_path content
    template_path=$(templates::internal::find "")
    if [[ -z "${template_path}" ]]; then
        return
    fi
    content=$(templates::internal::read "${template_path}")
    if [[ -z "${content}" ]]; then
        return
    fi
    case "${OSTYPE}" in
    darwin*)
        echo -n "${content}" | pbcopy
        ;;
    linux*)
        echo -n "${content}" | xclip -selection clipboard
        ;;
    esac
    message_success "Copied template: ${template_path}"
}

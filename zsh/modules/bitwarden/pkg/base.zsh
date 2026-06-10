# shellcheck shell=bash

function bw::value::factory {
    local item="${1}"
    local type
    type=$(_get_type "${item}")
    case "${type}" in
    1) bw::value::login "${item}" ;;
    2) bw::value::notes "${item}" ;;
    3) bw::value::cards "${item}" ;;
    esac
}

function bw::value::login {
    echo "${1}" | jq -r '.login.password // empty'
}

function bw::value::notes {
    echo "${1}" | jq -r '.notes // empty'
}

function bw::value::cards {
    echo "${1}" | jq -r '.card.number // empty'
}

function bw::search::login {
    local items
    items=$(bw list items 2>/dev/null) || return
    echo "${items}" | jq -r '.[] | select(.type==1) | .name'
}

function bw::search::notes {
    local items
    items=$(bw list items 2>/dev/null) || return
    echo "${items}" | jq -r '.[] | select(.type==2) | .name'
}

function bw::search::cards {
    local items
    items=$(bw list items 2>/dev/null) || return
    echo "${items}" | jq -r '.[] | select(.type==3) | .name'
}

function bw::search::all {
    local items
    items=$(bw list items 2>/dev/null) || return
    echo "${items}" | jq -r '.[].name'
}

function bw::search {
    local items selected item_id value
    items=$(bw list items 2>/dev/null) || return
    selected=$(echo "${items}" | jq -r '.[].name' | fzf --preview "echo {}" 2>/dev/null)
    [[ -z "${selected}" ]] && return
    value=$(echo "${items}" | jq -r ".[] | select(.name==\"${selected}\")" | _get_type_field)
    if [[ -n "${value}" ]]; then
        case "${OSTYPE}" in
        darwin*)
            echo -n "${value}" | pbcopy
            ;;
        linux*)
            echo -n "${value}" | xclip -selection clipboard
            ;;
        esac
        message_success "Copied ${selected} to clipboard"
    fi
}

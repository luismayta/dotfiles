# shellcheck shell=bash

function bw::value::factory {
    local item
    item=$(cat)
    local type
    type=$(echo "${item}" | jq -r '.type')
    case "${type}" in
    1) bw::value::login <<< "${item}" ;;
    2) bw::value::notes <<< "${item}" ;;
    3) bw::value::cards <<< "${item}" ;;
    esac
}

function bw::value::login {
    local item
    item=$(cat)
    echo "${item}" | jq -r '.login.password // empty'
}

function bw::value::notes {
    local item
    item=$(cat)
    echo "${item}" | jq -r '.notes // empty'
}

function bw::value::cards {
    local item
    item=$(cat)
    echo "${item}" | jq -r '.card.number // empty'
}

function bw::search::login {
    bw::load::env
    local items
    if ! items=$(bw list items); then
        message_warning "Failed to list Bitwarden items. Are you logged in?"
        return 1
    fi
    echo "${items}" | jq -r '.[] | select(.type==1) | .name'
}

function bw::search::notes {
    bw::load::env
    local items
    if ! items=$(bw list items); then
        message_warning "Failed to list Bitwarden items. Are you logged in?"
        return 1
    fi
    echo "${items}" | jq -r '.[] | select(.type==2) | .name'
}

function bw::search::cards {
    bw::load::env
    local items
    if ! items=$(bw list items); then
        message_warning "Failed to list Bitwarden items. Are you logged in?"
        return 1
    fi
    echo "${items}" | jq -r '.[] | select(.type==3) | .name'
}

function bw::search::all {
    bw::load::env
    local items
    if ! items=$(bw list items); then
        message_warning "Failed to list Bitwarden items. Are you logged in?"
        return 1
    fi
    echo "${items}" | jq -r '.[].name'
}

function bw::search {
    bw::load::env
    local items selected value
    if ! items=$(bw list items); then
        message_warning "Failed to list Bitwarden items. Are you logged in?"
        return 1
    fi
    selected=$(echo "${items}" | jq -r '.[].name' | fzf --preview "echo {}" 2>/dev/null)
    [[ -z "${selected}" ]] && return
    value=$(echo "${items}" | jq -r ".[] | select(.name==\"${selected}\")" | bw::value::factory)
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

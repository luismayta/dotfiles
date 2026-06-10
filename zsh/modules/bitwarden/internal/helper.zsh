# shellcheck shell=bash

function _get_type {
    echo "${1}" | jq -r '.type'
}

function _get_id {
    echo "${1}" | jq -r '.id'
}

function _get_type_field {
    local item="${1}"
    local type
    type=$(_get_type "${item}")
    case "${type}" in
    1) echo "${item}" | jq -r '.login.password // empty' ;;
    2) echo "${item}" | jq -r '.notes // empty' ;;
    3) echo "${item}" | jq -r '.card.number // empty' ;;
    *) echo "" ;;
    esac
}

function _get_item_by_type {
    local items="${1}"
    local type="${2}"
    echo "${items}" | jq -r ".[] | select(.type==${type})"
}

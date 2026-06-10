# shellcheck shell=bash

function issues::dependences {
    if ! core::exists gh && ! core::exists glab; then
        message_warning "Install gh (GitHub CLI) or glab (GitLab CLI)"
    fi
}

function issues::pkg::config::setup {
    if [[ ! -d "${ISSUES_RESOURCES_PATH}" ]]; then
        mkdir -p "${ISSUES_RESOURCES_PATH}"
    fi
}

function issues::provider::factory {
    issues::provider::factory
}

function issues {
    local action="${1}"
    case "${action}" in
    create)
        shift
        issues::task::create "${@}"
        ;;
    pr)
        shift
        issues::pr "${@}"
        ;;
    search)
        issues::search
        ;;
    "")
        issues::search
        ;;
    *)
        issues::task::create "${action} ${*}"
        ;;
    esac
}

# shellcheck shell=bash

function issues::internal::git::remote::detect {
    if ! core::exists git; then
        return 1
    fi
    local remote
    remote=$(git remote get-url origin 2>/dev/null)
    if [[ -z "${remote}" ]]; then
        return 1
    fi
    echo "${remote}"
}

function issues::internal::git::provider::detect {
    local remote
    remote=$(issues::internal::git::remote::detect) || return 1
    if echo "${remote}" | grep -qi "github"; then
        echo "github"
    elif echo "${remote}" | grep -qi "gitlab"; then
        echo "gitlab"
    else
        echo "unknown"
    fi
}

function issues::internal::git::branch::current {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function issues::internal::git::branch::base {
    echo "main"
}

# shellcheck shell=bash

function issues::task::create {
    local title="${1}"
    if [[ -z "${title}" ]]; then
        title=$(echo "" | fzf --print-query --placeholder="Enter issue title" 2>/dev/null | tail -1)
    fi
    if [[ -n "${title}" ]]; then
        gh issue create --title "${title}" --body ""
    fi
}

function issues::task::feat {
    gh issue create --title "feat: ${1}" --label "enhancement"
}

function issues::task::fix {
    gh issue create --title "fix: ${1}" --label "bug"
}

function issues::task::perf {
    gh issue create --title "perf: ${1}" --label "performance"
}

function issues::task::docs {
    gh issue create --title "docs: ${1}" --label "documentation"
}

function issues::task::refactor {
    gh issue create --title "refactor: ${1}" --label "refactor"
}

function issues::task::chore {
    gh issue create --title "chore: ${1}" --label "chore"
}

function issues::pr {
    local base_branch
    base_branch=$(issues::internal::git::branch::base)
    gh pr create --base "${base_branch}" --fill
}

function issues::pr::reviews {
    gh pr review --request
}

function issues::search {
    gh issue list --limit 30 | fzf
}

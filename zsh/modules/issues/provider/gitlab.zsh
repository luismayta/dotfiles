# shellcheck shell=bash

function issues::task::create {
    local title="${1}"
    if [[ -z "${title}" ]]; then
        title=$(echo "" | fzf --print-query --placeholder="Enter issue title" 2>/dev/null | tail -1)
    fi
    if [[ -n "${title}" ]]; then
        glab issue create --title "${title}"
    fi
}

function issues::task::feat {
    glab issue create --title "feat: ${1}" --label "enhancement"
}

function issues::task::fix {
    glab issue create --title "fix: ${1}" --label "bug"
}

function issues::task::perf {
    glab issue create --title "perf: ${1}" --label "performance"
}

function issues::task::docs {
    glab issue create --title "docs: ${1}" --label "documentation"
}

function issues::task::refactor {
    glab issue create --title "refactor: ${1}" --label "refactor"
}

function issues::task::chore {
    glab issue create --title "chore: ${1}" --label "chore"
}

function issues::pr {
    local base_branch
    base_branch=$(issues::internal::git::branch::base)
    glab mr create --target-branch "${base_branch}" --fill
}

function issues::pr::reviews {
    glab mr list --reviewer "@me" | fzf
}

function issues::search {
    glab issue list --per-page 30 | fzf
}

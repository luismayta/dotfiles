# shellcheck shell=bash

function issues::pr::body {
    local range="${1:-HEAD}"
    git log --oneline "${range}" --format="- %s (%an)"
}

function issues::pr::changes {
    local base="${1:-main}"
    git log --oneline "${base}..HEAD" --format="- %s (%an)"
}

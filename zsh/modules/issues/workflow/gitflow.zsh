# shellcheck shell=bash

function issues::pr::branch::base {
    local current_branch
    current_branch=$(issues::internal::git::branch::current)
    case "${current_branch}" in
    hotfix/*|release/*)
        echo "master"
        ;;
    *)
        echo "develop"
        ;;
    esac
}

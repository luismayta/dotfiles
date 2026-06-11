# shellcheck shell=bash
# shellcheck disable=SC2154 # Variables defined in config/base.zsh

# git::dependences::check — verify git user config
function git::dependences::check {
    if [ -z "${GITHUB_USER}" ]; then
        message_warning "You should set 'git config --global github.user'."
    fi
}

# git::pkg::config::setup — initialize global git config
function git::pkg::config::setup {
    if [ -n "${GIT_USER_NAME}" ] && [ -z "$(git config --global user.name 2>/dev/null)" ]; then
        git config --global user.name "${GIT_USER_NAME}"
    fi

    if [ -n "${GIT_USER_EMAIL}" ] && [ -z "$(git config --global user.email 2>/dev/null)" ]; then
        git config --global user.email "${GIT_USER_EMAIL}"
    fi

    if [ -n "${GITHUB_USER}" ] && [ -z "$(git config --global github.user 2>/dev/null)" ]; then
        git config --global github.user "${GITHUB_USER}"
    fi

    if [ -n "${GITHUB_TOKEN}" ]; then
        git config --global \
            url."https://${GITHUB_TOKEN}:@github.com/".insteadOf "https://github.com/"
    fi
}

# git::sync — sync hooks and config
function git::sync {
    git::internal::provision::hooks::sync
    git::internal::sync
}

# editgit — edit local .git/config in editor
function editgit {
    local path_git
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    path_git="$(git-root 2>/dev/null)"
    if [ -z "${path_git}" ]; then
        message_warning "it's not is path of git"
        return
    fi
    "${EDITOR}" "${path_git}/.git/config"
}

# editgitglobal — edit global git config in editor
function editgitglobal {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${GIT_FILE_SETTINGS}"
}

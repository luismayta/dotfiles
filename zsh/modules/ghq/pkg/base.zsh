# shellcheck shell=bash
# shellcheck disable=SC2154 # ZSH_GHQ_GITHUB_USER, ZSH_GHQ_CACHE_PROJECT, ZSH_GHQ_CACHE_PATH, ZSH_GHQ_REGEX_IS_REPOSITORY, ZSH_GHQ_ROOT, ZSH_GHQ_PACKAGE_NAME defined in config/base.zsh
# Public API — all ghq::* functions

function ghq::dependences::check {
    if [ -z "${ZSH_GHQ_GITHUB_USER}" ]; then
        message_warning "You should set 'git config --global github.user'."
    fi
    if [ -z "${PROJECTS:-}" ]; then
        message_warning "You should set path for projects"
    fi
}

function ghq::install {
    ghq::internal::install
}

function ghq::post_install {
    if core::exists git; then
        git config --global ghq.root "${PROJECTS:-${HOME}/projects}"
    fi
}

function ghq::projects::list {
    if [ ! -e "${ZSH_GHQ_CACHE_PROJECT}" ]; then
        ghq::cache::create::factory
        ghq::cache::list
        return
    fi
    ghq::cache::list
}

# reponame
function ghq::new {
    local repository repository_path
    repository="${1}"
    repository_path="$(ghq root)/github.com/${ZSH_GHQ_GITHUB_USER}/${repository}"
    ghq create "${repository}"
    ghq::cache::clear
    cd "${repository_path}" || cd - && git flow init -d
}

function ghq::new::template {
    local template repository_path
    repository_path="$(ghq root)/github.com/${ZSH_GHQ_GITHUB_USER}/"
    ghq::cookiecutter::find
    template="${ZSH_GHQ_COOKIECUTTER_TEMPLATE:-}"
    if [ -z "${template}" ]; then
        message_warning "Please Select one Project"
        return
    fi
    cd "${repository_path}" || cd - && \
        eval "cookiecutter ${template}" && \
        ghq::cache::clear
}

function ghq::factory {
    local repository repository_path is_repository
    repository="${1}"
    is_repository=$(echo "${repository}" | grep -cE "${ZSH_GHQ_REGEX_IS_REPOSITORY}")

    if [ -z "${repository}" ]; then
        ghq::new::template
        return
    fi

    if [ "${is_repository}" -eq 1 ]; then
        ghq get "${repository}"
        ghq::cache::clear
        return
    fi

    ghq::new "${repository}"
}

function ghq::find::project {
    if core::exists fzf; then
        local buffer
        buffer=$(ghq::projects::list | fzf)
        if [ -n "${buffer}" ]; then
            cd "$(ghq root)/${buffer}" || return
        fi
    fi
}

function ghq::get_remote_path_from_url {
    # git remote url may be
    # ssh://git@hoge.host:22/var/git/projects/Project
    # git@github.com:motemen/ghq.git
    # (normally considering only github is enough?)
    # remove ^.*://
    # => remove ^hoge@ (usually git@ ?)
    #  => replace : => /
    #   => remove .git$
    local remote_path
    remote_path=$(echo "${1}" | sed -e 's!^.*://!!; s!^.*@!!; s!:!/!; s!\.git$!!;')
    echo "${remote_path}"
}

function ghq::is_dir {
    local target_dir
    target_dir="${1}"
    if [ ! -d "${target_dir}" ]; then
        echo 0
        return
    fi
    echo 1
}

function ghq::git::get_origin_path {
    local target_dir origin_path
    target_dir="${1}"
    origin_path=$(
        cd "${target_dir}" || exit
        git config --get-regexp remote.origin.url | cut -d ' ' -f 2
    )
    echo "${origin_path}"
}

function ghq::cache::clear {
    [ -e "${ZSH_GHQ_CACHE_PROJECT}" ] && rm -rf "${ZSH_GHQ_CACHE_PROJECT}"
    ghq::cache::create::factory
}

function ghq::cache::list {
    [ -e "${ZSH_GHQ_CACHE_PROJECT}" ] && cat "${ZSH_GHQ_CACHE_PROJECT}"
}

function ghq::cache::create {
    [ -e "${ZSH_GHQ_CACHE_PATH}" ] || mkdir -p "${ZSH_GHQ_CACHE_PATH}"
    ghq list > "${ZSH_GHQ_CACHE_PROJECT}"
}

function ghq::cache::create::factory {
    ghq::cache::create
}

function ghq::migrate::move {
    local target_dir
    local remote_path
    local new_repo_dir
    target_dir="${1}"
    remote_path="${2}"

    message_info "move this repository to ${ZSH_GHQ_ROOT}/${remote_path}"

    new_repo_dir="${ZSH_GHQ_ROOT}/${remote_path}"

    if [ -e "${new_repo_dir}" ]; then
        message_warning "${new_repo_dir} already exists!!!!"
        return 0
    fi
    mkdir -p "${new_repo_dir%/*}"
    mv "${target_dir%/}" "${new_repo_dir}"
    message_success "${new_repo_dir} migrate!!!!"
}

# migrate repository path to root path
function ghq::migrate {
    local target_dir
    local origin_path
    local migrate_path

    target_dir="${1}"
    if [ ! "$(ghq::is_dir "${target_dir}")" ]; then
        message_info "${target_dir} not is directory"
    fi

    origin_path=$(ghq::git::get_origin_path "${target_dir}")

    if [ -z "${origin_path}" ]; then
        message_info "not found repository remote"
    fi

    migrate_path="$(ghq::get_remote_path_from_url "${origin_path}")"

    ghq::migrate::move "${target_dir}" "${migrate_path}"
}

function ghq::sync {
    message_info "No configuration files to sync for ${ZSH_GHQ_PACKAGE_NAME}."
}

# Auto-load dependencies on module init
ghq::dependences::check



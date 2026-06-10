# shellcheck shell=bash
# shellcheck disable=SC2154 # Variables defined in config/base.zsh

# git::internal::git::install — install git via brew
function git::internal::git::install {
    message_info "Installing ${GIT_PACKAGE_NAME}"
    if ! type -p brew > /dev/null; then
        message_warning "${CORE_MESSAGE_BREW}"
        return
    fi
    brew install git
    message_success "Installed ${GIT_PACKAGE_NAME}"
}

# git::internal::provision::hooks::sync — sync hooks from template
function git::internal::provision::hooks::sync {
    if [ ! -e "${GIT_PROVISION_HOOKS_PATH}" ]; then
        return
    fi
    rsync -avP --progress "${ZSH_GIT_HOOKS_PATH}/" "${GIT_PROVISION_HOOKS_PATH}/"
}

# git::internal::sync — sync config files to home
function git::internal::sync {
    rsync -avzh --progress "${ZSH_GIT_PATH}/sync/" "${HOME}/"
}

# git::internal::gunwipall — un-wip all recent --wip-- commits
function git::internal::gunwipall {
    local _commit
    _commit="$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)"

    # Check if a commit without "--wip--" was found and it's not the same as HEAD
    if [[ "${_commit}" != "$(git rev-parse HEAD)" ]]; then
        git reset "${_commit}" || return 1
    fi
}

# git::internal::git::user — get configured git user name
function git::internal::git::user {
    git config user.name
}

# git::internal::git::email — get configured git user email
function git::internal::git::email {
    git config user.email
}

# git::internal::git::branch::name — get current branch name
function git::internal::git::branch::name {
    git symbolic-ref --short HEAD
}

# git::internal::gitflow::branch::develop — get gitflow develop branch name
function git::internal::gitflow::branch::develop {
    git config --local gitflow.branch.develop || echo 'develop'
}

# git::internal::gitflow::branch::base — get gitflow base branch name
function git::internal::gitflow::branch::base {
    git config --local gitflow.branch.master || echo 'main'
}

# git::internal::gitflow::validate::exist::develop — check if develop branch exists
function git::internal::gitflow::validate::exist::develop {
    local response
    response="$(git config --local gitflow.branch.develop 2>/dev/null | cut -d ' ' -f 2)"
    if [ -n "${response}" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::internal::gitflow::validate::exist::master — check if master branch exists
function git::internal::gitflow::validate::exist::master {
    local response
    response="$(git config --local gitflow.branch.master 2>/dev/null | cut -d ' ' -f 2)"
    if [ -n "${response}" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::internal::gitflow::has_master::configured — alias for master check
function git::internal::gitflow::has_master::configured {
    git::internal::gitflow::validate::exist::master
}

# git::internal::gitflow::has_develop::configured — alias for develop check
function git::internal::gitflow::has_develop::configured {
    git::internal::gitflow::validate::exist::develop
}

# git::internal::gitflow::setup — initialize gitflow for repo
function git::internal::gitflow::setup {
    if [ "$(git::internal::gitflow::has_develop::configured)" -eq 0 ] || [ "$(git::internal::gitflow::has_master::configured)" -eq 0 ]; then
        git flow init -d
    fi
    git::internal::hook::factory
}

# git::internal::exist_hook — check if hook name matches regex
function git::internal::exist_hook {
    local hook_name
    hook_name="${1}"
    echo "${hook_name}" | grep -cE "${ZSH_GIT_REGEX_IS_HOOK}"
}

# git::internal::has_hook — check if hook file exists in .git/hooks
function git::internal::has_hook {
    local hook_name
    hook_name="${1}"
    if [ -e .git/hooks/"${hook_name}" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::internal::copy_hook — copy hook to project .git/hooks
function git::internal::copy_hook {
    local hook_name
    local has_hook
    hook_name="${1}"
    has_hook=$(git::internal::exist_hook "${hook_name}")
    if [ "${has_hook}" -eq 1 ]; then
        [ -e .git/hooks ] && cp -rf "${ZSH_GIT_HOOKS_PATH}/${hook_name}" .git/hooks/
        message_success "copy hook ${hook_name}"
        return
    fi
    message_warning "not found hook ${hook_name}"
}

# git::internal::hook::factory — install prepare-commit-msg hook
function git::internal::hook::factory {
    local hook_name
    hook_name=prepare-commit-msg
    if [ "$(git::internal::has_hook "${hook_name}")" -eq 0 ]; then
        git::internal::copy_hook "${hook_name}"
    fi
}

# git::internal::branch::task_name — extract task name from branch
function git::internal::branch::task_name {
    local branch_name
    branch_name="$(git::internal::git::branch::name)"
    branch_name="${branch_name##*/}"
    echo "${branch_name}"
}

# git::internal::branch::is_develop — check if on develop branch
function git::internal::branch::is_develop {
    if [ "$(git::internal::git::branch::name)" = "$(git::internal::gitflow::branch::develop)" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::internal::repository::remote::url — get remote URL
function git::internal::repository::remote::url {
    local remote_name
    remote_name="${1}"
    git remote get-url "${remote_name}" 2>/dev/null || echo
}

# git::internal::repository::fork::private — check if origin != upstream
function git::internal::repository::fork::private {
    local domain_origin domain_upstream
    domain_origin=$(git::internal::repository::remote::url origin | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
    domain_upstream=$(git::internal::repository::remote::url upstream | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
    if [ -z "${domain_upstream}" ]; then
        echo 0
        return
    fi

    if [ "${domain_origin}" != "${domain_upstream}" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::internal::gff::publish — push branch to appropriate remote
function git::internal::gff::publish {
    local branch_name
    branch_name="$(git::internal::git::branch::name)"
    if [ "$(git::internal::repository::fork::private)" -eq 1 ]; then
        git push upstream "${branch_name}"
        return
    fi
    git push origin "${branch_name}"
}

# git::internal::gff::sync — sync branches with remote
function git::internal::gff::sync {
    if [ -z "$(git::internal::repository::remote::url origin)" ]; then
        return
    fi
    message_info "starting sync branches"
    if [ "$(git::internal::branch::is_develop)" -eq 0 ]; then
        git checkout "$(git::internal::gitflow::branch::develop)"
    fi
    git-sync
    message_success "finish sync branches"
}

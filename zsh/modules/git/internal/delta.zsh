# shellcheck shell=bash
# shellcheck disable=SC2154 # Variables defined in config/base.zsh

# git::internal::delta::install — install delta via nix
function git::internal::delta::install {
    if core::exists delta; then
        return 0
    fi

    message_info "Installing delta"
    if core::nix::package::install "${GIT_DELTA_NIX_PACKAGE}"; then
        message_success "Installed delta"
    else
        message_error "Failed to install delta"
        return 1
    fi
}

# git::internal::delta::load — apply delta git config
function git::internal::delta::load {
    if ! core::exists delta; then
        return 0
    fi

    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global merge.conflictStyle zdiff3
}

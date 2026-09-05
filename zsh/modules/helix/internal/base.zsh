# shellcheck shell=bash
#
# Internal core logic for the helix module.
# Implements helix config sync, install, and grammar management.

function helix::internal::sync {
    message_info "Syncing helix configuration..."
    command mkdir -p "${ZSH_HELIX_CONFIG_PATH}"
    command rsync -avzh --progress --delete \
        "${ZSH_HELIX_DATA_PATH}/" \
        "${ZSH_HELIX_CONFIG_PATH}/"
    message_success "Synced helix configuration"
}

function helix::internal::install {
    core::ensure "${ZSH_HELIX_PACKAGE_NAME}"
    message_success "helix: installed"
}

function helix::internal::post_install {
    message_info "helix: fetching and building runtime grammars..."
    "${ZSH_HELIX_PACKAGE_NAME}" --grammar fetch
    "${ZSH_HELIX_PACKAGE_NAME}" --grammar build
    message_success "helix: runtime grammars updated"
}

function helix::internal::backup {
    message_info "Backing up helix configuration..."
    local apply_flag=""
    if [[ "$1" == "--apply" ]]; then
        apply_flag="--apply"
        shift
    fi

    local rsync_opts="-avzh --progress --delete"
    if [[ -z "${apply_flag}" ]]; then
        rsync_opts="${rsync_opts} --dry-run"
        message_info "Dry run mode (use --apply to apply)"
    fi

    command rsync "${rsync_opts}" \
        "${ZSH_HELIX_CONFIG_PATH}/" \
        "${ZSH_HELIX_DATA_PATH}/"
    message_success "helix: backup complete"
}

function helix::internal::upgrade {
    message_info "Upgrading helix..."
    core::ensure "${ZSH_HELIX_PACKAGE_NAME}"
    "${ZSH_HELIX_PACKAGE_NAME}" --grammar fetch
    "${ZSH_HELIX_PACKAGE_NAME}" --grammar build
    message_success "helix: upgraded"
}

function helix::internal::clean {
    message_info "Cleaning helix cache and state..."
    command rm -rf "${ZSH_HELIX_CACHE_HOME}"
    command rm -rf "${ZSH_HELIX_STATE_HOME}"
    message_success "helix: cache and state cleaned"
}
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
    core::ensure helix
    message_success "helix: installed"
}

function helix::internal::post_install {
    message_info "helix: fetching and building runtime grammars..."
    hx --grammar fetch
    hx --grammar build
    message_success "helix: runtime grammars updated"
}
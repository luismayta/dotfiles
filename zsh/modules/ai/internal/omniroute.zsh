#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# OmniRoute internal functions

# === PATH Loading ===

function ai::internal::omniroute::load {
    if ! core::exists omniroute; then
        return
    fi
    # bun global bin already in PATH — no-op
}

# === Tool Install ===

function ai::internal::omniroute::install {
    if core::exists omniroute; then
        return 0
    fi

    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Installing ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"
    if "${=ZSH_AI_OMNIROUTE_INSTALL_CMD}" "${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"; then
        message_success "${ZSH_AI_OMNIROUTE_PACKAGE_NAME} installed successfully"
    else
        message_error "Failed to install ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"
        return 1
    fi
}

# === Tool Upgrade ===

function ai::internal::omniroute::upgrade {
    if ! core::exists omniroute; then
        ai::internal::omniroute::install
        return
    fi

    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Upgrading ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"
    if bun add -g "${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"@latest --force; then
        message_success "Upgraded ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"
    else
        message_error "Failed to upgrade ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}"
        return 1
    fi
}

# === Config Sync ===

function ai::internal::omniroute::sync {
    if [[ ! -d "${ZSH_AI_OMNIROUTE_DATA_PATH}" ]]; then
        return
    fi

    message_info "Syncing ${ZSH_AI_OMNIROUTE_PACKAGE_NAME} configuration"
    mkdir -p "${ZSH_AI_OMNIROUTE_CONFIG_DIR}"
    rsync -avzh --progress "${ZSH_AI_OMNIROUTE_DATA_PATH}/" "${ZSH_AI_OMNIROUTE_CONFIG_DIR}/"
    message_success "Synced ${ZSH_AI_OMNIROUTE_PACKAGE_NAME} configuration"
}

ai::internal::omniroute::load

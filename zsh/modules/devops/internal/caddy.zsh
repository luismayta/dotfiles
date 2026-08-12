#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::caddy::internal::load {
    if ! core::exists caddy; then
        return
    fi

    # caddy is available on PATH
}

function devops::caddy::internal::install {
    if core::exists caddy; then
        message_info "${DEVOPS_CADDY_PACKAGE_NAME} already installed"
        return 0
    fi

    message_info "Installing ${DEVOPS_CADDY_PACKAGE_NAME}"
    core::install "${DEVOPS_CADDY_PACKAGE_NAME}"
    message_success "Installed ${DEVOPS_CADDY_PACKAGE_NAME}"
}

function devops::caddy::internal::upgrade {
    if ! core::exists caddy; then
        devops::caddy::internal::install
        return
    fi

    message_info "Upgrading ${DEVOPS_CADDY_PACKAGE_NAME}"
    caddy upgrade
    message_success "Upgraded ${DEVOPS_CADDY_PACKAGE_NAME}"
}

function devops::caddy::internal::sync {
    if ! core::exists caddy; then
        message_error "${DEVOPS_CADDY_PACKAGE_NAME} is not installed. Run devops::caddy::install first."
        return 1
    fi

    message_info "Syncing ${DEVOPS_CADDY_PACKAGE_NAME} configuration"
    mkdir -p "${DEVOPS_CADDY_CONFIG_DIR}"
    ln -sf "${DEVOPS_CADDY_DATA_PATH}/Caddyfile" "${DEVOPS_CADDY_CONFIG_FILE}"
    message_success "Linked Caddyfile -> ${DEVOPS_CADDY_CONFIG_FILE}"
}

function devops::caddy::internal::run {
    devops::caddy::internal::sync
    message_info "Running ${DEVOPS_CADDY_PACKAGE_NAME} (foreground, Caddyfile: ${DEVOPS_CADDY_CONFIG_FILE})"
    caddy run --config "${DEVOPS_CADDY_CONFIG_FILE}"
}

function devops::caddy::internal::reload {
    message_info "Reloading ${DEVOPS_CADDY_PACKAGE_NAME} (Caddyfile: ${DEVOPS_CADDY_CONFIG_FILE})"
    caddy reload --config "${DEVOPS_CADDY_CONFIG_FILE}"
    message_success "Reloaded ${DEVOPS_CADDY_PACKAGE_NAME}"
}

function devops::caddy::internal::main::factory {
    core::ensure caddy
}

devops::caddy::internal::load
devops::caddy::internal::main::factory

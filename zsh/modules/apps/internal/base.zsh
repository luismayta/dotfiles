# shellcheck shell=bash

apps::internal::packages::install() {
    message_info "Installing required ${APPS_PACKAGE_NAME} packages"
    for package in "${APPS_PACKAGES[@]}"; do
        core::ensure "${package}"
    done
    message_success "Installed required ${APPS_PACKAGE_NAME} packages"
}

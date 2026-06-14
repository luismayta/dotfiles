# shellcheck shell=bash

apps::packages::install() {
    apps::internal::packages::install
}

apps::sync() {
    message_info "Syncing ${APPS_PACKAGE_NAME} configuration..."
    message_success "${APPS_PACKAGE_NAME} configuration synced."
}

apps::upgrade() {
    message_warning "method not implemented"
}

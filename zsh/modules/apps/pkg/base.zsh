# shellcheck shell=bash

apps::packages::install() {
    apps::internal::packages::install
}

apps::sync() {
    message_info "Syncing ${APPS_PACKAGE_NAME} configuration..."
    message_success "${APPS_PACKAGE_NAME} configuration synced."
}

# Build and install all configured webapps idempotently
apps::webapp::all::install() {
    apps::internal::webapp::all::install
}

apps::upgrade() {
    message_warning "method not implemented"
}

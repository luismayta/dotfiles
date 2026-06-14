# shellcheck shell=bash

apps::packages::install() {
    apps::internal::packages::install
}

apps::sync() {
    message_info "Syncing ${APPS_PACKAGE_NAME} configuration..."
    message_success "${APPS_PACKAGE_NAME} configuration synced."
}

apps::webapp::build() {
    apps::internal::webapp::build "${@}"
}

apps::webapp::all::build() {
    apps::internal::webapp::all::build
}

apps::upgrade() {
    message_warning "method not implemented"
}

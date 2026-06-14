# shellcheck shell=bash

apps::packages::install() {
    apps::internal::packages::install
}

apps::sync() {
    message_info "Syncing ${APPS_PACKAGE_NAME} configuration..."
    message_success "${APPS_PACKAGE_NAME} configuration synced."
}

# Build a single webapp from a URL
# Usage: apps::webapp::build <url> <name>
apps::webapp::build() {
    apps::internal::webapp::build "${@}"
}

# Build all configured webapps from APPS_WEB_APPS_BUILD
# Cleans and recreates APPS_WEB_APPS_BUILD_DIR before building
apps::webapp::all::build() {
    apps::internal::webapp::all::build
}

# Install a previously built webapp artifact
# Usage: apps::webapp::install <name>
# Linux: paru -U <name>.pkg.tar.zst | macOS: open <name>.app
apps::webapp::install() {
    apps::internal::webapp::install "${@}"
}

apps::upgrade() {
    message_warning "method not implemented"
}

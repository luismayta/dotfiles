# shellcheck shell=bash

apps::internal::packages::install() {
    message_info "Installing required ${APPS_PACKAGE_NAME} packages"
    for package in "${APPS_PACKAGES[@]}"; do
        core::install "${package}"
    done
    message_success "Installed required ${APPS_PACKAGE_NAME} packages"
}

apps::internal::webapp::all::build() {
    if [[ ${#APPS_WEB_APPS_BUILD[@]} -eq 0 ]]; then
        message_info "No web apps configured to build"
        return 0
    fi

    message_info "Building all configured web apps"
    local entry name url
    for entry in "${APPS_WEB_APPS_BUILD[@]}"; do
        name="${entry%%:*}"
        url="${entry#*:}"
        apps::internal::webapp::build "${url}" "${name}" || true
    done
    message_success "Finished building web apps"
}

apps::internal::webapp::build() {
    local url="${1}"
    local name="${2}"

    if [[ -z "${url}" ]]; then
        message_error "URL is required for webapp::build"
        return 1
    fi

    if [[ -z "${name}" ]]; then
        message_error "Name is required for webapp::build"
        return 1
    fi

    if ! core::exists pake; then
        message_error "pake is required but not installed"
        return 1
    fi

    message_info "Building web app: ${name} (${url})"
    if pake "${url}" --name "${name}" --width 1200 --height 800 --hide-title-bar --targets zst; then
        message_success "Built web app: ${name}"
    else
        message_error "Failed to build web app: ${name}"
        return 1
    fi
}
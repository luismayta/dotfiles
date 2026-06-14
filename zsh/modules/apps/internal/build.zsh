# shellcheck shell=bash

apps::internal::webapp::all::build() {
    if [[ ${#APPS_WEB_APPS_BUILD[@]} -eq 0 ]]; then
        message_info "No web apps configured to build"
        return 0
    fi

    message_info "Building all configured web apps"

    # Clean and recreate build directory
    if [[ -d "${APPS_WEB_APPS_BUILD_DIR}" ]]; then
        rm -rf "${APPS_WEB_APPS_BUILD_DIR}"
    fi
    mkdir -p "${APPS_WEB_APPS_BUILD_DIR}"

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

    # Ensure build directory exists
    mkdir -p "${APPS_WEB_APPS_BUILD_DIR}"

    message_info "Building web app: ${name} (${url})"

    if ! pake "${url}" \
        --name "${name}" \
        --width 1200 \
        --height 800 \
        --hide-title-bar \
        --hide-menu \
        --targets zst \
        --target-path "${APPS_WEB_APPS_BUILD_DIR}"; then
        message_error "Failed to build web app: ${name}"
        return 1
    fi

    # Rename artifact to canonical lowercase name
    local artifact
    artifact=$(find "${APPS_WEB_APPS_BUILD_DIR}" -maxdepth 1 -name "${name}*.pkg.tar.zst" -print -quit 2>/dev/null)
    if [[ -n "${artifact}" ]]; then
        # shellcheck disable=SC2296
        mv "${artifact}" "${APPS_WEB_APPS_BUILD_DIR}/${(L)name}.pkg.tar.zst"
        message_success "Built web app: ${name}"
    else
        message_warning "Built web app: ${name}, but artifact not found for rename"
    fi
}

apps::internal::webapp::install() {
    local name="${1}"

    if [[ -z "${name}" ]]; then
        message_error "Name is required for webapp::install"
        return 1
    fi

    # shellcheck disable=SC2296
    local artifact="${APPS_WEB_APPS_BUILD_DIR}/${(L)name}.pkg.tar.zst"

    if [[ ! -f "${artifact}" ]]; then
        message_error "Artifact not found: ${artifact}"
        return 1
    fi

    case "${OSTYPE}" in
        linux*)
            if ! core::exists paru; then
                message_error "paru is required but not installed"
                return 1
            fi
            message_info "Installing ${name} via paru..."
            if paru -U "${artifact}" --noconfirm; then
                message_success "Installed web app: ${name}"
            else
                message_error "Failed to install web app: ${name}"
                return 1
            fi
            ;;
        darwin*)
            message_info "Opening ${name} app bundle..."
            if open "${APPLICATION_PATH}/${name}.app" 2>/dev/null; then
                message_success "Opened web app: ${name}"
            else
                message_error "Failed to open web app: ${name}"
                return 1
            fi
            ;;
        *)
            message_error "Unsupported OS: ${OSTYPE}"
            return 1
            ;;
    esac
}

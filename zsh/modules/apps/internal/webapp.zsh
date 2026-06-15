# shellcheck shell=bash

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

    pushd "${APPS_WEB_APPS_BUILD_DIR}" >/dev/null || return 1
    if ! pake "${url}" \
        --name "${name}" \
        --width 1200 \
        --height 800 \
        --hide-title-bar \
        --targets zst; then
        popd >/dev/null || true
        message_error "Failed to build web app: ${name}"
        return 1
    fi
    popd >/dev/null || true

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
    [[ -z "${name}" ]] && { message_error "Name is required for webapp::install"; return 1; }

    case "${OSTYPE}" in
        linux*)
            if ! core::exists paru; then
                message_error "paru is required but not installed"
                return 1
            fi
            # shellcheck disable=SC2296
            local artifact="${APPS_WEB_APPS_BUILD_DIR}/${(L)name}.pkg.tar.zst"
            if [[ ! -f "${artifact}" ]]; then
                message_error "Artifact not found: ${artifact}"
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
            if open "${APPS_APPLICATION_PATH}/${name}.app" 2>/dev/null; then
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

apps::internal::webapp::all::install() {
    if [[ ${#APPS_WEB_APPS_BUILD[@]} -eq 0 ]]; then
        message_info "No web apps configured to install"
        return 0
    fi

    message_info "Installing all configured web apps"

    mkdir -p "${APPS_WEB_APPS_BUILD_DIR}"

    local entry name url artifact
    for entry in "${APPS_WEB_APPS_BUILD[@]}"; do
        name="${entry%%:*}"
        url="${entry#*:}"
        # shellcheck disable=SC2296
        artifact="${APPS_WEB_APPS_BUILD_DIR}/${(L)name}.pkg.tar.zst"

        # Check if already installed
        # shellcheck disable=SC2296
        if core::exists "pake-${(L)name}" || [[ -d "${APPS_APPLICATION_PATH}/${name}.app" ]]; then
            message_info "Web app already installed: ${name}"
            continue
        fi

        # Build if artifact missing
        if [[ ! -f "${artifact}" ]]; then
            apps::internal::webapp::build "${url}" "${name}" || continue
        fi

        apps::internal::webapp::install "${name}" || continue
    done
    message_success "Finished installing web apps"
}



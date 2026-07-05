# shellcheck shell=bash

function herdr::internal::install {
    if core::exists herdr; then
        message_info "${HERDR_PACKAGE_NAME} is already installed."
        return 0
    fi

    core::ensure curl

    message_info "Installing ${HERDR_PACKAGE_NAME}..."
    if curl -fsSL "${HERDR_INSTALL_URL}" | sh; then
        if core::exists herdr; then
            message_success "${HERDR_PACKAGE_NAME} installed successfully"
            return 0
        fi
        message_warning "${HERDR_PACKAGE_NAME} install script ran but binary not found in PATH"
    fi

    message_error "Failed to install ${HERDR_PACKAGE_NAME}"
    return 1
}

function herdr::internal::config::sync {
    local src="${ZSH_HERDR_DATA_PATH}"
    local dst="${HERDR_CONFIG_PATH}"

    if [[ ! -d "$src" ]] || [[ -z "$(ls -A "$src" 2>/dev/null)" ]]; then
        message_info "No ${HERDR_PACKAGE_NAME} config found in data path"
        return 0
    fi

    mkdir -p "$dst"
    message_info "Syncing ${HERDR_PACKAGE_NAME} config..."

    if rsync -avzh "$src/" "$dst/"; then
        message_success "${HERDR_PACKAGE_NAME} config synced successfully"
    else
        message_error "Failed to sync ${HERDR_PACKAGE_NAME} config"
        return 1
    fi
}

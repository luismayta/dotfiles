# shellcheck shell=bash
# noti backend implementation

# === Install ===

function notify::noti::internal::install {
    if core::exists noti; then
        return 0
    fi

    if core::internal::nix::exists; then
        message_info "Installing noti via nix..."
        if nix --extra-experimental-features 'nix-command flakes' profile add nixpkgs#noti; then
            message_success "noti installed successfully via nix"
        else
            message_error "Failed to install noti via nix"
            return 1
        fi
    else
        message_info "Installing noti via package manager..."
        if core::install "${ZSH_NOTIFY_NOTI_PACKAGE_NAME}"; then
            message_success "noti installed successfully"
        else
            message_error "Failed to install noti"
            return 1
        fi
    fi
}

# === Config ===

function notify::noti::internal::sync {
    local src="${ZSH_NOTIFY_NOTI_DATA_PATH}"
    local dst="${ZSH_NOTIFY_NOTI_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "noti config synced"
    else
        message_warning "no noti config source at ${src}"
    fi

    # Generate config from template if not present
    if [[ ! -f "${ZSH_NOTIFY_NOTI_CONFIG_FILE}" ]]; then
        notify::noti::internal::render
    fi
}

function notify::noti::internal::render {
    if [[ -z "${ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN}" ]] || [[ -z "${ZSH_NOTIFY_NOTI_TELEGRAM_CHATID}" ]]; then
        message_error "noti: Telegram token or chatId not set"
        return 1
    fi

    if ! core::exists gomplate; then
        message_info "noti: gomplate is not installed. Installing via core module..."
        if core::gomplate::install; then
            message_success "noti: gomplate installed successfully"
        else
            message_error "noti: Failed to install gomplate"
            return 1
        fi
    fi

    mkdir -p "${ZSH_NOTIFY_NOTI_CONFIG_PATH}"

    local template="${ZSH_NOTIFY_NOTI_DATA_PATH}/noti.yaml.tpl"

    if [[ ! -f "$template" ]]; then
        message_error "noti: template not found at ${template}"
        return 1
    fi

    if gomplate -f "$template" -o "${ZSH_NOTIFY_NOTI_CONFIG_FILE}"; then
        message_success "noti: Config written to ${ZSH_NOTIFY_NOTI_CONFIG_FILE}"
    else
        message_error "noti: Failed to render config template"
        return 1
    fi
}

# === Send ===

function notify::noti::internal::send {
    if ! core::exists noti; then
        message_error "noti: noti is not installed. Run: notify::noti::install"
        return 1
    fi

    # $1 command that was executed
    # $2 message to display
    # $3 icon filename (optional)
    local icon
    if [[ -n "${3:-}" ]] && [[ -f "${ZSH_NOTIFY_ASSETS_PATH}/${3}" ]]; then
        icon="${ZSH_NOTIFY_ASSETS_PATH}/${3}"
    fi

    if [[ -n "$icon" ]]; then
        noti -t "${1}" -m "${2}" --icon "$icon" 2>/dev/null
    else
        noti -t "${1}" -m "${2}" 2>/dev/null
    fi
}

# === Adapter Contract ===

function notify::adapter::send {
    notify::noti::internal::send "${1}" "${2}" "${3}"
}

function notify::adapter::install {
    notify::noti::internal::install
}

function notify::adapter::render {
    notify::noti::internal::render
}

function notify::adapter::sync {
    notify::noti::internal::sync
}
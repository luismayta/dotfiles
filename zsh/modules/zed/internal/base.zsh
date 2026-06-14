# shellcheck shell=bash

function zed::internal::install {
    if core::exists zed; then
        return 0
    fi
    message_info "Installing Zed Editor..."
    if curl -f "${ZED_INSTALL_URL}" | bash; then
        message_success "Zed Editor installed successfully."
    else
        message_error "Failed to install Zed Editor."
        return 1
    fi
}

function zed::internal::config::sync {
    message_info "Synchronizing Zed configuration..."
    local config_source="${ZED_PATH}/resources"
    local config_target="${ZED_CONFIG_PATH}"
    if [[ ! -d "${config_target}" ]]; then
        mkdir -p "${config_target}"
    fi
    rsync -avzh --progress "${config_source}/" "${config_target}/"
    message_success "Synchronized Zed configuration."
}

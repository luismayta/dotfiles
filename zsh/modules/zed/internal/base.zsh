# shellcheck shell=bash

function zed::internal::install {
    if core::exists zed; then
        return 0
    fi
    message_info "Installing ${ZED_PACKAGE_NAME} Editor..."
    if curl -f "${ZED_INSTALL_URL}" | bash; then
        message_success "${ZED_PACKAGE_NAME} Editor installed successfully."
    else
        message_error "Failed to install ${ZED_PACKAGE_NAME} Editor."
        return 1
    fi
}

function zed::internal::config::sync {
    rsync -avzh --progress "${ZSH_ZED_DATA_PATH}/" "${ZED_CONFIG_PATH}/"
}
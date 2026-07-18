# shellcheck shell=bash
# Linux-specific keybase internals (currently unused)
#
function keybase::internal::install {
    if core::exists keybase; then
        return 0
    fi
    message_info "Installing ${ZSH_KEYBASE_PACKAGE_NAME}..."
    core::install keybase-bin
    message_success "${ZSH_KEYBASE_PACKAGE_NAME} installed successfully."
}

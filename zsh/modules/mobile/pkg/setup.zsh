# shellcheck shell=bash

function android::setup {
    message_info "Setting up Android SDK..."
    if ! core::exists adb; then
        android::install
    else
        message_info "Android SDK is already installed."
    fi
    android::load
    message_success "Android SDK setup complete."
}

function flutter::setup {
    message_info "Setting up ${FLUTTER_PACKAGE_NAME} SDK..."
    if ! core::exists flutter; then
        flutter::install
    else
        message_info "${FLUTTER_PACKAGE_NAME} SDK is already installed."
    fi
    flutter::load
    flutter::post_install
    message_success "${FLUTTER_PACKAGE_NAME} SDK setup complete."
}

# --- iOS ---

function ios::setup {
    case "${OSTYPE}" in
    darwin*)
        mobile::internal::ios::install
        mobile::internal::ios::load
        ;;
    *)
        message_info "iOS setup is only supported on macOS."
        ;;
    esac
}

function mobile::setup {
    message_info "Setting up ${MOBILE_PACKAGE_NAME} development environment..."
    android::setup
    if [[ "${FLUTTER_ENABLED:-true}" == "true" ]]; then
        flutter::setup
    fi
    ios::setup
    message_success "${MOBILE_PACKAGE_NAME} development environment setup complete."
}

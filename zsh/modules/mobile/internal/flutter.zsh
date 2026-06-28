# shellcheck shell=bash
# mobile module — Flutter internal functions

function mobile::internal::flutter::install {
    local flutter_url="${FLUTTER_DOWNLOAD_URL}/${FLUTTER_FILE}"
    local flutter_parent
    flutter_parent="$(dirname "${FLUTTER_ROOT}")"

    message_info "Installing ${FLUTTER_PACKAGE_NAME} SDK ${FLUTTER_VERSION}..."
    mkdir -p "${flutter_parent}"

    case "${OSTYPE}" in
    darwin*)
        local tmp_zip
        tmp_zip="$(mktemp).zip"
        if curl -fsSL "${flutter_url}" -o "${tmp_zip}"; then
            unzip -q "${tmp_zip}" -d "${flutter_parent}"
            rm -f "${tmp_zip}"
            message_success "${FLUTTER_PACKAGE_NAME} SDK installed at ${FLUTTER_ROOT}."
        else
            message_error "Failed to download ${FLUTTER_PACKAGE_NAME} from ${flutter_url}."
            return 1
        fi
        ;;
    linux*)
        if curl -fsSL "${flutter_url}" | tar xJ -C "${flutter_parent}"; then
            message_success "${FLUTTER_PACKAGE_NAME} SDK installed at ${FLUTTER_ROOT}."
        else
            message_error "Failed to download ${FLUTTER_PACKAGE_NAME} from ${flutter_url}."
            return 1
        fi
        ;;
    esac
}

function mobile::internal::flutter::load {
    if [[ -d "${FLUTTER_ROOT_BIN}" ]]; then
        export PATH="${FLUTTER_ROOT_BIN}:${PATH}"
    fi
    if [[ -d "${FLUTTER_DART_SDK_BIN}" ]]; then
        export PATH="${FLUTTER_DART_SDK_BIN}:${PATH}"
    fi
    if [[ -d "${PUB_BIN_PATH}" ]]; then
        export PATH="${PUB_BIN_PATH}:${PATH}"
    fi
}

function mobile::internal::flutter::upgrade {
    message_warning "${FLUTTER_PACKAGE_NAME} upgrade: method not implemented."
    message_info "Use 'flutter upgrade' directly or remove ${FLUTTER_ROOT} and reload."
}

function mobile::internal::flutter::post_install {
    case "${OSTYPE}" in
    darwin*)
        if core::exists flutter; then
            message_info "Configuring ${FLUTTER_PACKAGE_NAME} for Android SDK..."
            if [[ -n "${ANDROID_HOME:-}" ]]; then
                flutter config --android-sdk "${ANDROID_HOME}" 2>/dev/null || true
                yes | flutter doctor --android-licenses --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
            fi
        fi
        ;;
    esac
}

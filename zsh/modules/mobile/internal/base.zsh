# shellcheck shell=bash
# mobile module — shared internal implementation

function mobile::internal::android::install {
    message_info "Installing Android SDK packages..."

    # Install brew packages via core::ensure
    for package in "${APPS_ANDROID[@]}"; do
        core::ensure "${package}"
    done

    # Ensure Java is available (required for sdkmanager) via SDKMAN
    if ! java -version &>/dev/null; then
        message_info "Java not found. Installing SDKMAN and JDK 17..."
        if ! core::exists sdk; then
            curl -s "${SDKMAN_INSTALL_URL}" | bash
        fi
        if [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
            # shellcheck disable=SC1091
            source "${SDKMAN_DIR}/bin/sdkman-init.sh"
            sdk install java "${SDKMAN_JAVA_VERSION}"
            sdk default java "${SDKMAN_JAVA_VERSION}"
        fi
    fi

    # Install sdkmanager if missing
    if ! core::exists sdkmanager; then
        message_info "Installing Android command-line tools..."
        case "${OSTYPE}" in
        darwin*)
            core::ensure android-commandlinetools
            mkdir -p "${ANDROID_HOME}/cmdline-tools/latest"
            if [[ -d "$(brew --prefix 2>/dev/null)/share/android-commandlinetools" ]]; then
                cp -R "$(brew --prefix)/share/android-commandlinetools/"* "${ANDROID_HOME}/cmdline-tools/latest/"
            fi
            ;;
        linux*)
            local cmdline_url="https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip"
            local tmp_zip
            tmp_zip="$(mktemp).zip"
            mkdir -p "${ANDROID_HOME}/cmdline-tools"
            if curl -fsSL "${cmdline_url}" -o "${tmp_zip}"; then
                unzip -q "${tmp_zip}" -d "${ANDROID_HOME}/cmdline-tools/"
                if [[ -d "${ANDROID_HOME}/cmdline-tools/cmdline-tools" ]]; then
                    mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest"
                fi
                rm -f "${tmp_zip}"
            else
                message_warning "Failed to download Android command-line tools."
            fi
            ;;
        esac
    fi

    # Install SDK components via sdkmanager
    if core::exists sdkmanager; then
        message_info "Installing Android SDK components via sdkmanager..."
        sdkmanager --update --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "cmdline-tools;latest" --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}" --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "platform-tools" --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "build-tools;${ANDROID_SDK_VERSION}" --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "extras;google;m2repository" --sdk_root="${ANDROID_HOME}"
        yes | sdkmanager "extras;android;m2repository" --sdk_root="${ANDROID_HOME}"
        message_success "Android SDK components installed."
    else
        message_warning "sdkmanager not available. Install android-commandlinetools and try again."
    fi

    message_success "Android SDK packages installed."
}

function mobile::internal::android::load {
    if [[ -d "${ANDROID_PLATFORM_TOOLS}" ]]; then
        export PATH="${ANDROID_PLATFORM_TOOLS}:${PATH}"
    fi
    if [[ -d "${ANDROID_HOME}/cmdline-tools/latest/bin" ]]; then
        export PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"
    fi
    if [[ -d "${ANDROID_HOME}/build-tools/${ANDROID_SDK_VERSION}" ]]; then
        export PATH="${ANDROID_HOME}/build-tools/${ANDROID_SDK_VERSION}:${PATH}"
    fi
    if [[ -d "${ANDROID_HOME}/emulator" ]]; then
        export PATH="${ANDROID_HOME}/emulator:${PATH}"
    fi
}

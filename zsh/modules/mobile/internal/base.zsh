# shellcheck shell=bash
# mobile module — shared internal implementation

function mobile::internal::android::install {
    message_info "Installing Android SDK packages..."

    # Install brew packages via core::ensure
    for package in "${APPS_ANDROID[@]}"; do
        core::ensure "${package}"
    done

    # Ensure Java is available (required for sdkmanager)
    if ! core::exists java; then
        message_info "Java not found. Installing OpenJDK..."
        core::ensure openjdk@11
        core::ensure openjdk@17
        core::ensure openjdk@21
    fi

    # Install sdkmanager if missing
    if ! core::exists sdkmanager; then
        message_info "Installing Android command-line tools..."
        core::ensure android-commandlinetools
        mkdir -p "${ANDROID_HOME}/cmdline-tools/latest"
        if [[ -d "$(brew --prefix 2>/dev/null)/share/android-commandlinetools" ]]; then
            cp -R "$(brew --prefix)/share/android-commandlinetools/"* "${ANDROID_HOME}/cmdline-tools/latest/"
        fi
    fi

    # Install SDK components via sdkmanager
    if core::exists sdkmanager; then
        message_info "Installing Android SDK components via sdkmanager..."
        sdkmanager --update --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "cmdline-tools;latest" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "platform-tools" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "build-tools;${ANDROID_SDK_VERSION}" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "extras;google;m2repository" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
        yes | sdkmanager "extras;android;m2repository" --sdk_root="${ANDROID_HOME}" 2>/dev/null || true
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
}

# shellcheck shell=bash
# mobile module — macOS internal functions (iOS tooling)

function mobile::internal::ios::install {
    case "${OSTYPE}" in
    darwin*)
        message_info "Installing iOS development tools..."

        if ! core::exists gem; then
            message_warning "RubyGems (gem) not found. Cannot install CocoaPods."
            return 1
        fi

        if ! core::exists brew; then
            message_warning "Homebrew not found. Cannot install iOS tools."
            return 1
        fi

        message_info "Installing CocoaPods..."
        gem install cocoapods

        message_info "Installing usbmuxd..."
        brew install --HEAD usbmuxd
        brew link usbmuxd 2>/dev/null || true

        message_info "Installing libimobiledevice..."
        brew install --HEAD libimobiledevice

        message_info "Installing ideviceinstaller and ios-deploy..."
        brew install ideviceinstaller ios-deploy

        message_success "iOS development tools installed."
        ;;
    *)
        message_info "iOS development tools are only available on macOS."
        ;;
    esac
}

function mobile::internal::ios::load {
    case "${OSTYPE}" in
    darwin*)
        # Add CocoaPods bin to PATH if it exists
        if [[ -d "${HOME}/.cocoapods" ]]; then
            export PATH="${HOME}/.cocoapods/bin:${PATH}"
        fi
        # Add CocoaPods Ruby gem bin if it exists
        if core::exists gem; then
            local pod_bin
            pod_bin="$(gem environment gemdir 2>/dev/null)/bin"
            if [[ -d "${pod_bin}" ]]; then
                export PATH="${pod_bin}:${PATH}"
            fi
        fi
        ;;
    esac
}

function mobile::internal::ios::upgrade {
    case "${OSTYPE}" in
    darwin*)
        message_warning "iOS tool upgrade: use individual tool upgrade commands."
        message_info "  gem update cocoapods"
        message_info "  brew upgrade usbmuxd libimobiledevice ideviceinstaller ios-deploy"
        ;;
    esac
}

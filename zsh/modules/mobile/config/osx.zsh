# shellcheck shell=bash
# macOS-specific mobile configuration

export FLUTTER_FILE="macos/flutter_macos_arm64_${FLUTTER_VERSION}.zip"

# iOS development tooling configuration
export IOS_PACKAGE_NAME=ios

# iOS tools managed via core::ensure or direct install
# shellcheck disable=SC2034 # referenced from internal/main.zsh
APPS_IOS=(
    cocoapods
    usbmuxd
    libimobiledevice
    ideviceinstaller
    ios-deploy
)

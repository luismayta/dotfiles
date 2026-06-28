# shellcheck shell=bash
# Linux-specific mobile configuration

export FLUTTER_FILE="linux/flutter_linux_${FLUTTER_VERSION}.tar.xz"

# Android packages managed via core::ensure (Linux/AUR names)
# shellcheck disable=SC2034 # referenced from internal/main.zsh
APPS_ANDROID=(android-studio android-sdk-platform-tools)

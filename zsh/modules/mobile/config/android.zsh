# shellcheck shell=bash
# Android SDK configuration

export ANDROID_HOME="${ANDROID_HOME:-${HOME}/Android/Sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-${ANDROID_HOME}}"
export ANDROID_PLATFORM_TOOLS="${ANDROID_HOME}/platform-tools"
export ANDROID_PLATFORM_VERSION="${ANDROID_PLATFORM_VERSION:-37}"
export ANDROID_SDK_VERSION="${ANDROID_SDK_VERSION:-37.0.0}"
export ANDROID_FILE_REPOSITORIES="${HOME}/.android/repositories.cfg"

# SDKMAN / Java provisioning
export SDKMAN_INSTALL_URL="${SDKMAN_INSTALL_URL:-https://get.sdkman.io?rcupdate=false}"
export SDKMAN_JAVA_VERSION="${SDKMAN_JAVA_VERSION:-17.0.13-tem}"

# Android packages managed via core::ensure
# shellcheck disable=SC2034 # referenced from internal/main.zsh
APPS_ANDROID=(android-studio android-platform-tools)

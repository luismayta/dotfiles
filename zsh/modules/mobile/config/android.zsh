# shellcheck shell=bash
# Android SDK configuration

export ANDROID_HOME="${ANDROID_HOME:-${HOME}/Android/Sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-${ANDROID_HOME}}"
export ANDROID_PLATFORM_TOOLS="${ANDROID_HOME}/platform-tools"

# Android packages managed via core::ensure
# shellcheck disable=SC2034 # referenced from internal/main.zsh
APPS_ANDROID=(android-studio android-platform-tools)

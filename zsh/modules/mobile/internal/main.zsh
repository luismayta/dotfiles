# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/internal/base.zsh"
source "${ZSH_MOBILE_PATH}/internal/flutter.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_MOBILE_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_MOBILE_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl
core::ensure unzip

# Android: install packages + load paths
if ! core::exists adb; then
    mobile::internal::android::install
fi
mobile::internal::android::load

# Flutter: auto-install if missing, then load into PATH (disabled via FLUTTER_ENABLED=false)
if [[ "${FLUTTER_ENABLED:-true}" == "true" ]]; then
    if ! core::exists flutter; then
        mobile::internal::flutter::install
    fi
    mobile::internal::flutter::load
fi

# iOS: macOS-only, auto-install if Flutter is present (heuristic for iOS dev intent)
case "${OSTYPE}" in
darwin*)
    if core::exists flutter && ! core::exists pod; then
        mobile::internal::ios::install
    fi
    mobile::internal::ios::load
    ;;
esac

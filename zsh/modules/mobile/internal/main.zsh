# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/internal/base.zsh"

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

# Flutter: auto-install if missing, then load into PATH
if ! core::exists flutter; then
    mobile::internal::flutter::install
fi
mobile::internal::flutter::load

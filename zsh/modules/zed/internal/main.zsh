# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZED_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZED_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZED_PATH}/internal/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZED_PATH}/internal/helper.zsh"

core::ensure curl
if ! core::exists zed; then zed::internal::install; fi

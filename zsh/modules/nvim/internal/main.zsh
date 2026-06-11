# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Internal layer - OS dispatch + auto-install.
# Sources OS-specific overrides, ensures dependencies, and auto-installs nvimrc.

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_NVIM_PATH}/internal/osx.zsh"
    ;;
  linux*)
    source "${ZSH_NVIM_PATH}/internal/linux.zsh"
    ;;
esac

source "${ZSH_NVIM_PATH}/internal/base.zsh"

# Ensure required tools are installed
core::ensure "${NVIM_PACKAGE_NAME}"
core::ensure "rsync"

# Auto-install nvimrc configuration
if [[ ! -d "${NVIM_CONFIG_PATH}" ]]; then
  nvim::internal::install
fi

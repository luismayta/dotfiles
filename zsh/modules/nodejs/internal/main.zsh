# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/internal/base.zsh"
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_NODEJS_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_NODEJS_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/internal/helper.zsh"

core::ensure curl
core::ensure unzip

nodejs::internal::fnm::load
nodejs::internal::bunx::load

if ! core::exists fnm; then nodejs::internal::fnm::install; fi

if ! core::exists bun; then nodejs::internal::bun::install; fi
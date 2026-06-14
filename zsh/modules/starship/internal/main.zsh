# shellcheck shell=bash
# Starship internal main loader

# shellcheck source=/dev/null
source "${ZSH_STARSHIP_PATH}/internal/base.zsh"

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_STARSHIP_PATH}/internal/osx.zsh"
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_STARSHIP_PATH}/internal/linux.zsh"
    ;;
esac

starship::internal::main::factory

starship::internal::load

if ! core::exists rsync; then core::install rsync; fi
if ! core::exists starship; then core::install starship; fi
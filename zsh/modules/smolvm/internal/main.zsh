# shellcheck shell=bash
# shellcheck source=/dev/null

# Sourcing order respects dependencies:
#   base (verify) → install
source "${ZSH_SMOLVM_PATH}/internal/base.zsh"
source "${ZSH_SMOLVM_PATH}/internal/install.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_SMOLVM_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_SMOLVM_PATH}/internal/linux.zsh"
  ;;
esac

core::ensure curl

# Auto-install smolvm if missing
if ! core::exists smolvm; then
  smolvm::internal::install && smolvm::internal::verify
fi

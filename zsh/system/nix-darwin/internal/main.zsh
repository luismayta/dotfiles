# shellcheck shell=bash
source "${NIX_DARWIN_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/internal/osx.zsh" ;;
linux*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/internal/linux.zsh" ;;
esac

# Ensure nix is available (installs on first load if missing)
nix::darwin::internal::ensure

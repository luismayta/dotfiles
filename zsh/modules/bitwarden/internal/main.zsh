# shellcheck shell=bash
# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${BITWARDEN_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${BITWARDEN_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/internal/helper.zsh"

if ! core::exists fzf; then core::install fzf; fi
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists bw; then core::install bw; fi

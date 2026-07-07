# shellcheck shell=bash
# shellcheck source=/dev/null
source "${SSH_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${SSH_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${SSH_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${SSH_PATH}/internal/helper.zsh"

core::ensure curl
core::ensure fzf
core::ensure jq
core::ensure assh

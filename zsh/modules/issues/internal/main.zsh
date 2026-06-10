# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ISSUES_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ISSUES_PATH}/internal/helper.zsh"

if ! core::exists rsync; then core::install rsync; fi
if ! core::exists less; then core::install less; fi
if ! core::exists fzf; then core::install fzf; fi

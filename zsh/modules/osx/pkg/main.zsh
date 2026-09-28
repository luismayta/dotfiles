# shellcheck shell=bash
#
# osx / pkg / main — the public API layer.
#
# Same shape as zed/pkg/main.zsh: base first, because it defines the wrappers
# the orchestrator composes; then the platform dispatch; then the orchestrator;
# then the aliases. Every source is unconditional, so a file missing from disk is
# a broken shell load rather than a quiet no-op — which is why pkg/alias.zsh
# exists even though it defines nothing.
#
# On Linux this file is not reached through the module: plugin.zsh returns at
# `$ZSH_OSX_ENABLED || return` after config/main.zsh, because config/linux.zsh
# sets ZSH_OSX_ENABLED=false. The two stubs below still exist so the platform
# decision stays visible in the file tree, and so platform-specific
# implementation added later is a change to one file rather than a structural
# refactor.
#

# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_OSX_PATH}/pkg/osx.zsh" ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_OSX_PATH}/pkg/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/pkg/helper.zsh"
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/pkg/alias.zsh"

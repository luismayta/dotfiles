# shellcheck shell=bash

# Antidote - internal layer entry

# shellcheck source=/dev/null
source "${ZSH_ANTIDOTE_PATH}"/internal/base.zsh

# Auto-install on load (idempotent)
antidote::internal::antidote::install

# Antidote - internal layer entry
source "${ZSH_ANTIDOTE_PATH}"/internal/base.zsh

# Auto-install on load (idempotent)
antidote::internal::antidote::install

# Antidote - plugin manager module
# Load order: config -> internal -> pkg

[[ -n "${__ZSH_ANTIDOTE_LOADED:-}" ]] && return
__ZSH_ANTIDOTE_LOADED=1

# Module root path
ZSH_ANTIDOTE_PATH="${0:A:h}"

message_info "Loading module: antidote"

source "${ZSH_ANTIDOTE_PATH}"/config/main.zsh
$ZSH_ANTIDOTE_ENABLED || return
source "${ZSH_ANTIDOTE_PATH}"/internal/main.zsh
source "${ZSH_ANTIDOTE_PATH}"/pkg/main.zsh

# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_YAZI_PATH}/internal/base.zsh"

core::ensure curl

# Auto-install yazi if missing
if ! core::exists yazi; then
    yazi::internal::install
fi

# shellcheck shell=bash
# Linux-specific config (CachyOS/Arch)

export PARU_BIN_PATH="/usr/bin"

# shellcheck disable=SC2034 # Used in internal/api.zsh via multiplatform::install
CORE_LINUX_PACKAGES=(
  wl-clipboard
  xclip
  xsel
)

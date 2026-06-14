# shellcheck shell=bash

export PATH="${PATH}:${HOMEBREW_BIN_PATH}"

# shellcheck disable=SC2034 # Used in internal/api.zsh via multiplatform::install
CORE_PACKAGES=(
  zsh
  git
  rsync
  jq
  ag
  fd
  ripgrep
  cmake
  ksh
)
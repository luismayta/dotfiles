# shellcheck shell=bash

export PATH="${PATH}:${HOMEBREW_BIN_PATH}"

# Shell & Core
CORE_PACKAGES+=(
  zsh
  git
  rsync
  ksh
)

# CLI Utilities
CORE_PACKAGES+=(
  jq
  ag
  fd
  ripgrep
)

# Build & Dev Tools
CORE_PACKAGES+=(
  cmake
  direnv
)

# Fonts
CORE_PACKAGES+=(
  font-fira-code-nerd-font
  font-jetbrains-mono-nerd-font
  font-source-code-pro-nerd-font
)

# Document Conversion
CORE_PACKAGES+=(
  pandoc
)

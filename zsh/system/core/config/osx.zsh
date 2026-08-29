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

# Fonts (casks)
CORE_CASKS+=(
  font-fira-code-nerd-font
  font-jetbrains-mono-nerd-font
  font-sauce-code-pro-nerd-font
)

# Document Conversion
CORE_PACKAGES+=(
  pandoc
)

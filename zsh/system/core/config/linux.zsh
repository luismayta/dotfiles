# shellcheck shell=bash
# Linux-specific config (CachyOS/Arch)

export PARU_BIN_PATH="/usr/bin"

# Clipboard
CORE_PACKAGES+=(
  wl-clipboard
  xclip
  xsel
)

# Fonts
CORE_PACKAGES+=(
  ttf-firacode-nerd
  ttf-jetbrains-mono-nerd
  ttf-sourcecodepro-nerd
)

# Shell & Core
CORE_PACKAGES+=(
  git
  gcc
  rsync
  zsh
  ksh
)

# CLI Utilities
CORE_PACKAGES+=(
  fd
  ripgrep
)

# Build Dependencies
CORE_PACKAGES+=(
  webkit2gtk-4.1
  gtk3
  libsoup3
  pkgconf
  base-devel
  libappindicator-gtk3
)

# Audio & Display
CORE_PACKAGES+=(
  pipewire
  wireplumber
  xdg-desktop-portal
  xdg-desktop-portal-hyprland
)

# Media & Utilities
CORE_PACKAGES+=(
  grim
  slurp
  ffmpeg
  p7zip
  poppler
  fd
  ueberzugpp
)

# File Management
CORE_PACKAGES+=(
  dolphin
  direnv
  udisks2
  udiskie
)

# Document Conversion
CORE_PACKAGES+=(
  pandoc-cli
)
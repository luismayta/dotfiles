#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Linux desktop environment packages (Arch/CachyOS)
# Sourced from provision/script/functions.sh → dotfiles_install_factory
#
# Categories:
#   - Window Manager: i3
#   - Audio: pulseaudio, jack, alsa
#   - Notifications: dunst
#   - Theming: GTK themes, fonts
#   - File Management: thunar
#   - PDF: zathura
#   - Utilities: misc apps and tools

packages=(
  # Window Manager
  i3-gaps
  i3blocks-gaps-git
  compton
  arandr

  # Audio
  alsa-utils
  pulseaudio
  pulseaudio-alsa
  pulseaudio-jack
  jack2
  pavucontrol
  playerctl
  qjackctl

  # Notifications
  dunst

  # Theming
  gtk-chtheme
  arc-gtk-theme
  lxappearance
  ttf-inconsolata-g
  ttf-meslo
  ttf-monaco

  # File Management
  thunar
  thunar-volman

  # PDF
  zathura
  zathura-pdf-poppler

  # Applications & Utilities
  rofi
  feh
  flameshot
  flatpak
  neovim
  pandoc
  speedcrunch
  termite
  cups
  graphviz
  python2-lxml
  python2-scour
  autojump
  tree
)

for package in "${packages[@]}"; do
  paru -S --noconfirm "${package}"
done

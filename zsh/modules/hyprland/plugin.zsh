# shellcheck shell=bash
# Hyprland ZSH module
#
# Provides Hyprland installation, configuration sync, and helper commands
# for managing the Hyprland Wayland compositor.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_HYPRLAND_LOADED:-}" ]] && return
__ZSH_HYPRLAND_LOADED=1

# Module root path — used by all sourced sub-files
HYPRLAND_PATH="$(dirname "${0}")"
message_info "Loading module: hyprland"

# shellcheck source=/dev/null
source "${HYPRLAND_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${HYPRLAND_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${HYPRLAND_PATH}/pkg/main.zsh"

# Auto-install guards (must be after pkg/main.zsh so hyprland::post_install exists)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists fzf; then core::install fzf; fi
if ! core::exists Hyprland; then hyprland::internal::hyprland::install; fi

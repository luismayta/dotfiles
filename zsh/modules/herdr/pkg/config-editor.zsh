# shellcheck shell=bash

# ──────────────────────────────────────────────
# Config editor helpers
# ──────────────────────────────────────────────

# edit-herdr-config — open herdr config.toml in $EDITOR.
# Port of edittmux from the tmux module.
function edit-herdr-config {
  if [[ -z "${EDITOR}" ]]; then
    message_warning "EDITOR is not set."
    return 1
  fi

  local config_file="${ZSH_HERDR_CONFIG_PATH}/config.toml"

  if [[ ! -f "$config_file" ]]; then
    message_warning "Config file not found: $config_file"
    return 1
  fi

  "${EDITOR}" "$config_file"
}

# edit-herdr-plugins — open herdr plugins directory in $EDITOR.
function edit-herdr-plugins {
  if [[ -z "${EDITOR}" ]]; then
    message_warning "EDITOR is not set."
    return 1
  fi

  local plugins_dir="${ZSH_HERDR_CONFIG_PATH}/plugins"

  if [[ ! -d "$plugins_dir" ]]; then
    message_warning "Plugins directory not found: $plugins_dir"
    return 1
  fi

  "${EDITOR}" "$plugins_dir"
}

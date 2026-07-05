# shellcheck shell=bash

# ──────────────────────────────────────────────
# Workspace helpers (hrd / hrdk)
# ──────────────────────────────────────────────

# Wrapper for herdr command, with optional TMUX-like socket support.
_hrd() {
  command herdr "$@"
}

# hrd — switch or create herdr workspace via fzf.
# Port of ftm (fuzzy tmux) from the tmux module.
# Without arguments: list workspaces via fzf, switch to selected.
# With argument: switch to named workspace (create if missing).
function hrd {
  if [[ -n "${1}" ]]; then
    hrd::internal::switch_workspace "${1}"
    return
  fi

  local workspaces
  workspaces="$(hrd::internal::list_workspaces 2>/dev/null)" || {
    message_info "No herdr workspaces found. Create one with: herdr workspace create --label <name>"
    return 1
  }

  local selection
  selection="$(
    printf '%s\n' "$workspaces" \
      | hrd::internal::fzf_select "Switch workspace: "
  )"

  if [[ -n "$selection" ]]; then
    hrd::internal::switch_workspace "$selection"
  fi
}

# hrdk — kill a herdr workspace via fzf.
# Port of ftmk (fuzzy tmux kill) from the tmux module.
# Without arguments: list workspaces via fzf, kill selected.
# With argument: kill named workspace.
function hrdk {
  if [[ -n "${1}" ]]; then
    hrd::internal::kill_workspace "${1}"
    return
  fi

  local workspaces
  workspaces="$(hrd::internal::list_workspaces 2>/dev/null)" || {
    message_info "No herdr workspaces found."
    return 1
  }

  local selection
  selection="$(
    printf '%s\n' "$workspaces" \
      | hrd::internal::fzf_select "Kill workspace: "
  )"

  if [[ -n "$selection" ]]; then
    hrd::internal::kill_workspace "$selection"
  fi
}

# ──────────────────────────────────────────────
# Project launcher
# ──────────────────────────────────────────────

# hrd::project — launch a new herdr project from a template.
# Port of tx::project from the tmux module.
# Without arguments: interactive fzf template selection + name derivation.
# With argument: use provided project name.
function hrd::project {
  if [[ ! -d "${ZSH_HRD_PROJECT_TEMPLATE_PATH}" ]]; then
    message_error "Project templates directory not found: ${ZSH_HRD_PROJECT_TEMPLATE_PATH}"
    return 1
  fi

  local template_count
  template_count="$(hrd::internal::list_templates | wc -l | tr -d ' ')"
  if [[ "$template_count" -eq 0 ]]; then
    message_error "No project templates found in ${ZSH_HRD_PROJECT_TEMPLATE_PATH}"
    return 1
  fi

  local selected_template
  selected_template="$(hrd::internal::select_template)"

  local project_name
  project_name="$(hrd::internal::derive_project_name "${1:-}")"

  if [[ -z "${project_name}" ]]; then
    message_error "Could not determine a valid project name."
    return 1
  fi

  hrd::internal::workspace_attach_or_create "${project_name}" && return

  message_info "Creating workspace '${project_name}'..."
  if herdr workspace create --label "${project_name}" --focus 2>/dev/null; then
    message_success "Workspace '${project_name}' created from template '${selected_template}'."
  else
    message_error "Failed to create workspace '${project_name}'."
    return 1
  fi
}

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

    local config_file="${HERDR_CONFIG_PATH}/config.toml"

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

    local plugins_dir="${HERDR_CONFIG_PATH}/plugins"

    if [[ ! -d "$plugins_dir" ]]; then
        message_warning "Plugins directory not found: $plugins_dir"
        return 1
    fi

    "${EDITOR}" "$plugins_dir"
}

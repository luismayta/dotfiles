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

# hrd::project — create a herdr workspace with 3-pane IDE layout.
# Port of tx::project from the tmux module.
# Without arguments: derives project name from directory context.
# With argument: use provided project name.
function hrd::project {
  local project_name
  project_name="$(hrd::internal::derive_project_name "${1:-}")"

  if [[ -z "${project_name}" ]]; then
    message_error "Could not determine a valid project name."
    return 1
  fi

  # If workspace already exists, prompt to attach (or decline)
  if hrd::internal::workspace_attach_or_create "$project_name"; then
    return 0
  fi

  # Create workspace with focus in pane 1; capture workspace_id for rename
  local ws_json ws_id
  ws_json="$(herdr workspace create --label "$project_name" --cwd "$PWD" --focus 2>/dev/null)" || {
    message_error "Failed to create workspace '${project_name}'."
    return 1
  }
  ws_id="$(printf '%s\n' "$ws_json" | jq -r '.result.workspace.workspace_id')"

  # Layout: 3 panes — editor (left 60%) | log (right-top) / shell (right-bottom)
  # ┌─────────────────┬──────────────┐
  # │                 │  pane 2      │
  # │   pane 1        │  (shell)     │
  # │   (editor)      ├──────────────┤
  # │                 │  pane 3      │
  # │                 │  (agent)     │
  # └─────────────────┴──────────────┘

  # Split pane 1 right at 60%; focus moves to the new right pane
  herdr pane split --current --direction right --ratio 0.6

  # Split right pane down at 50%; focus moves to new bottom-right pane
  herdr pane split --current --direction down --ratio 0.5

  # Name the panes for visual clarity (pane_id format: <workspace_id>:p<N>)
  herdr pane rename "${ws_id}:p1" "editor"
  herdr pane rename "${ws_id}:p2" "shell"
  herdr pane rename "${ws_id}:p3" "agent"

  message_success "Project workspace '${project_name}' created."
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

    local config_file="${ZSH_HERDR_CONFIG_DIR}/config.toml"

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

    local plugins_dir="${ZSH_HERDR_CONFIG_DIR}/plugins"

    if [[ ! -d "$plugins_dir" ]]; then
        message_warning "Plugins directory not found: $plugins_dir"
        return 1
    fi

    "${EDITOR}" "$plugins_dir"
}

# shellcheck shell=bash

# ──────────────────────────────────────────────
# Project launcher
# ──────────────────────────────────────────────

# hrd::start — launch herdr routed by the active terminal emulator.
# Uses HERDR_WORKSPACE to select the per-emulator session passed to herdr
# through the --session flag.
function hrd::start {
  if ! core::exists herdr; then
    message_error "herdr is not installed."
    return 1
  fi

  if [[ -z "${HERDR_WORKSPACE:-}" ]]; then
    message_info "HERDR_WORKSPACE is not set; starting herdr without routing."
    command herdr
  elif [[ -z "${HERDR_ENV:-}" ]]; then
    command herdr --session "${HERDR_WORKSPACE}"
  else
    # Already inside a herdr pane: herdr auto-attaches to the ambient session.
    command herdr
  fi
}

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

  # Set up 3-pane IDE layout via shared helper
  hrd::internal::pane::setup_3_pane_layout "$ws_id"

  message_success "Project workspace '${project_name}' created."
}

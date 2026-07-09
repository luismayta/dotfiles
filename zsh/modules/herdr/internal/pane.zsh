# shellcheck shell=bash

# ──────────────────────────────────────────────
# Pane layout helpers
# ──────────────────────────────────────────────

# Set up the standard 3-pane IDE layout in a workspace.
# Layout:
#   ┌──────────────┬─────────────────┐
#   │  pane 1      │                 │
#   │  (editor)    │  pane 3         │
#   ├──────────────┤  (agent)        │
#   │  pane 2      │                 │
#   │  (shell)     │                 │
#   └──────────────┴─────────────────┘
# Arguments:
#   $1 - workspace ID (required)
# Returns: 0 on success, 1 on failure (non-fatal, caller should not abort).
function hrd::internal::pane::setup_3_pane_layout {
  local ws_id="$1"

  if [[ -z "$ws_id" ]]; then
    message_warning "pane::setup_3_pane_layout: no workspace ID provided"
    return 1
  fi

  # Split pane p1 right at 50% — p1 becomes left, p2 becomes right (agent)
  herdr pane split "${ws_id}:p1" --direction right --ratio 0.5 2>/dev/null || {
    message_warning "Failed to split pane right (workspace: ${ws_id})"
    return 1
  }

  # Split the left pane (p1) down at 50% — p1 becomes top-left (editor), p3 becomes bottom-left (shell)
  herdr pane split "${ws_id}:p1" --direction down --ratio 0.5 2>/dev/null || {
    message_warning "Failed to split pane down (workspace: ${ws_id})"
    return 1
  }

  # Name the panes for visual clarity (pane_id format: <workspace_id>:p<N>)
  # Layout after splits: p1 (top-left, 50%) = editor, p2 (bottom-left, 50%) = shell, p3 (right, 100%) = agent
  herdr pane rename "${ws_id}:p1" "editor"  2>/dev/null || true
  herdr pane rename "${ws_id}:p2" "agent"   2>/dev/null || true
  herdr pane rename "${ws_id}:p3" "shell"   2>/dev/null || true

  return 0
}
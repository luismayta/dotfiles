# shellcheck shell=bash

# ──────────────────────────────────────────────
# Pane layout helpers
# ──────────────────────────────────────────────

# Set up the standard 3-pane IDE layout in a workspace.
# Layout:
#   ┌─────────────────┬──────────────┐
#   │                 │  pane 2      │
#   │   pane 1        │  (editor)    │
#   │   (agent)       ├──────────────┤
#   │                 │  pane 3      │
#   │                 │  (shell)     │
#   └─────────────────┴──────────────┘
# Arguments:
#   $1 - workspace ID (required)
# Returns: 0 on success, 1 on failure (non-fatal, caller should not abort).
function hrd::internal::pane::setup_3_pane_layout {
  local ws_id="$1"

  if [[ -z "$ws_id" ]]; then
    message_warning "pane::setup_3_pane_layout: no workspace ID provided"
    return 1
  fi

  # Split pane p1 right at 60% using explicit pane ID to ensure correct workspace
  herdr pane split "${ws_id}:p1" --direction right --ratio 0.6 2>/dev/null || {
    message_warning "Failed to split pane right (workspace: ${ws_id})"
    return 1
  }

  # Split the new right pane (p2) down at 50% using explicit pane ID
  herdr pane split "${ws_id}:p2" --direction down --ratio 0.5 2>/dev/null || {
    message_warning "Failed to split pane down (workspace: ${ws_id})"
    return 1
  }

  # Name the panes for visual clarity (pane_id format: <workspace_id>:p<N>)
  # Layout after splits: p1 (left, 40%) = agent, p2 (top-right, 50%) = editor, p3 (bottom-right, 50%) = shell
  herdr pane rename "${ws_id}:p1" "agent"   2>/dev/null || true
  herdr pane rename "${ws_id}:p2" "editor"  2>/dev/null || true
  herdr pane rename "${ws_id}:p3" "shell"   2>/dev/null || true

  return 0
}
# shellcheck shell=bash

# ──────────────────────────────────────────────
# Pane layout helpers
# ──────────────────────────────────────────────

# Set up the standard 3-pane IDE layout in a single tab.
# Layout:
#   ┌──────────────┬─────────────────┐
#   │  pane 1      │                 │
#   │  (editor)    │  pane 3         │
#   ├──────────────┤  (agent)        │
#   │  pane 2      │                 │
#   │  (shell)     │                 │
#   └──────────────┴─────────────────┘
# Arguments:
#   $1 - tab ID (required, format: <workspace_id>:t<N>)
# Returns: 0 on success, 1 on failure.
function hrd::internal::pane::setup_tab_layout {
  local tab_id="$1"

  if [[ -z "$tab_id" ]]; then
    message_warning "pane::setup_tab_layout: no tab ID provided"
    return 1
  fi

  # Split pane p1 right at 50% — p1 becomes left, p2 becomes right (agent)
  herdr pane split "${tab_id}:p1" --direction right --ratio 0.5 2>/dev/null || {
    message_warning "Failed to split pane right (tab: ${tab_id})"
    return 1
  }

  # Split the left pane (p1) down at 50% — p1 becomes top-left (editor), p3 becomes bottom-left (shell)
  herdr pane split "${tab_id}:p1" --direction down --ratio 0.5 2>/dev/null || {
    message_warning "Failed to split pane down (tab: ${tab_id})"
    return 1
  }

  # Name the panes for visual clarity
  herdr pane rename "${tab_id}:p1" "editor"  2>/dev/null || true
  herdr pane rename "${tab_id}:p2" "agent"   2>/dev/null || true
  herdr pane rename "${tab_id}:p3" "shell"   2>/dev/null || true

  return 0
}

# Set up the standard 3-pane IDE layout in a workspace.
# Creates multiple tabs, each with independent 3-pane layout.
# Arguments:
#   $1 - workspace ID (required)
#   $2 - number of tabs to create (optional, default: 2)
# Returns: 0 on success, 1 on failure (non-fatal, caller should not abort).
function hrd::internal::pane::setup_3_pane_layout {
  local ws_id="$1"
  local num_tabs="${2:-2}"

  if [[ -z "$ws_id" ]]; then
    message_warning "pane::setup_3_pane_layout: no workspace ID provided"
    return 1
  fi

  # Validate num_tabs (must be >= 1)
  if [[ ! "$num_tabs" =~ ^[0-9]+$ ]] || [[ "$num_tabs" -lt 1 ]]; then
    message_warning "pane::setup_3_pane_layout: invalid num_tabs '$num_tabs' (must be >= 1)"
    return 1
  fi

  local tab_index
  for ((tab_index=1; tab_index<=num_tabs; tab_index++)); do
    local tab_id="${ws_id}:t${tab_index}"

    # Create tab (skip first tab - it already exists)
    if [[ "$tab_index" -gt 1 ]]; then
      herdr tab create --workspace "$ws_id" --label "$tab_index" 2>/dev/null || {
        message_warning "Failed to create tab $tab_index (workspace: ${ws_id})"
        continue
      }
    fi

    # Setup 3-pane layout for this tab
    hrd::internal::pane::setup_tab_layout "$tab_id" || continue
  done

  # Focus on first tab after completion
  herdr tab focus "${ws_id}:t1" 2>/dev/null || true

  return 0
}

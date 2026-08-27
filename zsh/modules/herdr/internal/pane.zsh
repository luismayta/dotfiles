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
# Get the first pane ID assigned to a given tab.
# Arguments:
#   $1 - workspace ID (required)
#   $2 - tab ID (required, format: <workspace_id>:t<N>)
# Returns: the pane_id on success (prints to stdout), empty on failure.
function hrd::internal::pane::get_tab_first_pane {
  local ws_id="$1"
  local tab_id="$2"

  if [[ -z "$ws_id" || -z "$tab_id" ]]; then
    message_warning "pane::get_tab_first_pane: missing workspace or tab ID"
    return 1
  fi

  herdr pane list --workspace "$ws_id" 2>/dev/null \
    | jq -r --arg tab "$tab_id" '.result.panes[]? | select(.tab_id == $tab) | .pane_id' 2>/dev/null \
    | head -n 1
}

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
#   $2 - base pane ID for this tab (optional, defaults to <workspace_id>:p1)
# Returns: 0 on success, 1 on failure.
function hrd::internal::pane::setup_tab_layout {
  local tab_id="$1"
  local base_pane_id="$2"

  if [[ -z "$tab_id" ]]; then
    message_warning "pane::setup_tab_layout: no tab ID provided"
    return 1
  fi

  # Extract workspace ID by stripping the ':tN' suffix (e.g. 'workspace123:t1' -> 'workspace123')
  local ws_id="${tab_id%:t*}"

  # Pane IDs are workspace-scoped, not tab-scoped. Use the first pane of this
  # tab as the base for splitting (defaults to p1 for the first tab).
  if [[ -z "$base_pane_id" ]]; then
    base_pane_id="${ws_id}:p1"
  fi

  # Split base pane right at 50% — base becomes left, new pane becomes right (agent)
  local agent_json
  agent_json="$(herdr pane split "$base_pane_id" --direction right --ratio 0.5 2>/dev/null)" || {
    message_warning "Failed to split pane right (tab: ${tab_id})"
    return 1
  }
  local agent_pane_id="$(printf '%s\n' "$agent_json" | jq -r '.result.pane.pane_id' 2>/dev/null)"

  # Split the left pane (base) down at 50% — base becomes top-left (editor), new pane becomes bottom-left (shell)
  local shell_json
  shell_json="$(herdr pane split "$base_pane_id" --direction down --ratio 0.5 2>/dev/null)" || {
    message_warning "Failed to split pane down (tab: ${tab_id})"
    return 1
  }
  local shell_pane_id="$(printf '%s\n' "$shell_json" | jq -r '.result.pane.pane_id' 2>/dev/null)"

  # Name the panes for visual clarity
  herdr pane rename "$base_pane_id" "editor"  2>/dev/null || true
  herdr pane rename "$agent_pane_id" "agent"   2>/dev/null || true
  herdr pane rename "$shell_pane_id" "shell"   2>/dev/null || true

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

    # Pane IDs are workspace-scoped, not tab-scoped. Resolve the first pane
    # of this tab so we split the correct base pane (not p1 from tab 1).
    local base_pane_id
    base_pane_id="$(hrd::internal::pane::get_tab_first_pane "$ws_id" "$tab_id")"

    # Setup 3-pane layout for this tab
    hrd::internal::pane::setup_tab_layout "$tab_id" "$base_pane_id" || continue
  done

  # Focus on first tab after completion
  herdr tab focus "${ws_id}:t1" 2>/dev/null || true

  return 0
}

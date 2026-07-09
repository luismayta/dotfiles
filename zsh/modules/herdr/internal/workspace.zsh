# shellcheck shell=bash

# ──────────────────────────────────────────────
# Workspace helpers
# ──────────────────────────────────────────────

# List all herdr workspaces by name.
# Runs herdr workspace list and parses the output.
# Returns: writes workspace names to stdout, one per line.
# Returns 0 if at least one workspace found, 1 if none or error.
function hrd::internal::list_workspaces {
    herdr workspace list 2>/dev/null | jq -r '.result.workspaces[]?.label // empty'
}

# Check if a herdr workspace exists by name.
# Arguments:
#   $1 - workspace name
# Returns: 0 if exists, 1 otherwise.
function hrd::internal::workspace_exists {
    local name="$1"
    [[ -z "$name" ]] && return 1
    hrd::internal::list_workspaces | grep -qFx "$name"
}

# Switch to a herdr workspace by name.
# Arguments:
#   $1 - workspace name
# Returns: 0 on success, 1 on failure.
function hrd::internal::switch_workspace {
    local name="$1"
    [[ -z "$name" ]] && return 1

    if hrd::internal::workspace_exists "$name"; then
        # Resolve workspace_id from label
        local workspace_id
        workspace_id="$(hrd::internal::resolve_workspace_id "$name")" || return 1

        if [[ -n "$workspace_id" ]]; then
            herdr workspace focus "$workspace_id" 2>/dev/null && return 0
        fi
    fi

    # If workspace doesn't exist, create and optionally switch
    herdr workspace create --label "$name" --focus 2>/dev/null && return 0
    return 1
}

# Kill (close) a herdr workspace by name.
# Arguments:
#   $1 - workspace name
# Returns: 0 on success, 1 on failure.
function hrd::internal::kill_workspace {
    local name="$1"
    [[ -z "$name" ]] && return 1

    local workspace_id
    workspace_id="$(hrd::internal::resolve_workspace_id "$name")" || return 1

    if [[ -z "$workspace_id" ]]; then
        message_error "Workspace '${name}' not found."
        return 1
    fi

    herdr workspace close "$workspace_id" 2>/dev/null && return 0
    return 1
}

# Check if a workspace already exists. If yes, prompt to attach.
# Arguments:
#   $1 - workspace name
# Returns:
#   0 if workspace exists (attached or declined; caller should stop)
#   1 if workspace does not exist (caller should continue to create)
function hrd::internal::workspace_attach_or_create {
  local workspace_name="$1"

  if hrd::internal::workspace_exists "$workspace_name"; then
    printf 'A herdr workspace "%s" already exists. ' "$workspace_name"
    # shellcheck disable=SC2162
    read -q "?Attach? (Y/n) "
    printf '\n'
    if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]]; then
      hrd::internal::switch_workspace "$workspace_name"
    fi
    return 0
  fi
 
  return 1
}

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
# Consumes the choke-point label resolver (hrd::internal::resolve_workspace_label
# in internal/base.zsh, design Risk 4) instead of its own grep, so the
# existence check and resolve_workspace_id can never disagree about whether a
# label exists. True when EITHER the new or the legacy form of the label is
# present in the workspace list — regardless of whether that entry carries a
# resolvable workspace_id.
# Arguments:
#   $1 - workspace name
# Returns: 0 if exists, 1 otherwise.
function hrd::internal::workspace_exists {
  local name="$1"
  [[ -z "$name" ]] && return 1
  hrd::internal::resolve_workspace_label "$name" >/dev/null
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

  # Double miss (design Risk 4): neither the new label nor the legacy
  # {parent}-{dir} form resolved and the caller is about to CREATE — warn
  # first so a workspace the user expected to reuse shows up as a visible
  # decision instead of a silent duplicate. Gated on BOTH conditions so the
  # message only ever names labels the resolver genuinely tried:
  #   1. workspace_name == new_label — the candidate WAS this directory's
  #      derived label, so the resolver's context gate let it through to the
  #      legacy lookup and BOTH named labels were looked up. An explicit
  #      argument (`hrd::project custom`) derives a different candidate; the
  #      resolver's gate rejects the legacy fallback for it, so the legacy
  #      label was NEVER tried and naming it would be misleading.
  #   2. new_label != legacy_label — the two labels DIFFER (this directory's
  #      derivation was changed by the prefix map). When they are identical
  #      — unmapped parent, HOME branches — the legacy fallback was never
  #      going to help, and warning here would fire on every genuinely new
  #      project and become noise nobody reads.
  local new_label legacy_label
  new_label="$(hrd::internal::derive_project_name "")"
  legacy_label="$(core::workspace::derive_name "" "")"
  if [[ "$workspace_name" == "$new_label" && "$new_label" != "$legacy_label" ]]; then
    message_warning "no workspace matches the new or legacy label; creating a new one (tried '${workspace_name}' and '${legacy_label}')"
  fi

  return 1
}

# shellcheck shell=bash

# ──────────────────────────────────────────────
# Base / shared helpers
# ──────────────────────────────────────────────

# Generic fzf selector with preview.
# Arguments:
#   $1 - prompt text (e.g., "Select workspace: ")
#   $2 - preview command (optional)
# STDIN: list of items to filter
# Returns: writes selected item to stdout, exits 1 if cancelled.
function hrd::internal::fzf_select {
  local prompt="${1:-Select: }"
  local preview="${2:-}"

  local fzf_opts=()
  fzf_opts+=(--prompt="$prompt")
  fzf_opts+=(--exit-0)

  if [[ -n "$preview" ]]; then
    fzf_opts+=(--preview "$preview")
    fzf_opts+=(--preview-window=right:60%)
  fi

  if ! core::exists fzf; then
    message_error "fzf is required but not installed."
    return 1
  fi

  fzf "${fzf_opts[@]}"
}

# The shared derivation helper lives in core (design D1) and, in the normal
# load order, is defined by core/main.zsh before this module loads
# (zsh/zshrc:23 vs the modules loop at :57). The bats prelude sources this
# file directly (stubbing core::exists but loading no core files), so source
# it on demand when missing — resolved from THIS file's location so it can
# never pick up a different checkout. No-op in the normal load order.
if [[ -z "${functions[core::workspace::derive_name]:-}" ]]; then
  # shellcheck source=/dev/null
  source "${0:A:h:h:h:h}/system/core/pkg/helper/workspace.zsh"
fi

# Derive a project name from an argument or directory context.
# Thin delegator over core::workspace::derive_name — the single shared
# derivation source consumed by herdr and tmux (design D1) — passing
# ZSH_HERDR_PARENT_PREFIX_MAP as the prefix map ($2). The helper consults the
# map ONLY in the {parent}-{dir} branch and ONLY against the raw parent name.
# If $1 is given, it is used as the project name (slugified; map not consulted).
# If $1 is omitted, derives from $PWD and $HOME:
#   $PWD == $HOME           -> "core"
#   parent == $HOME         -> "core-{current_dir}"
#   otherwise               -> "{prefix}-{current_dir}" when the parent has a
#                               non-empty map entry, else "{parent_dir}-{current_dir}"
# Returns: writes project name to stdout.
function hrd::internal::derive_project_name {
  core::workspace::derive_name "$1" "${ZSH_HERDR_PARENT_PREFIX_MAP:-}"
}

# Resolve which EXISTING workspace label a candidate label maps to — the
# single choke point for the legacy-label fallback (design Risk 4). The label
# is compared in two independent places (workspace_exists and
# resolve_workspace_id); consuming this one function from both is what keeps
# them from disagreeing and creating a duplicate workspace.
#
# Resolution order:
#   1. the candidate (new-form) label, if present in the workspace list;
#   2. the legacy {parent_dir}-{current_dir} form of the SAME directory
#      context, if present;
#   3. empty / failure.
#
# Worktree labels are "{project_context}/{branch_leaf}" and DO contain a
# slash, so the candidate is split on its LAST slash: only the context is
# re-derived, the leaf is reused verbatim. The candidate label itself is
# NEVER slugified — running derive_project_name over it would mangle both the
# slash and the leaf. The legacy context comes from
# core::workspace::derive_name with an EMPTY map (legacy labels predate the
# prefix map; same PWD/HOME context).
#
# The legacy fallback only applies when the candidate's context IS the label
# currently derived for this directory: an arbitrary name must not match an
# unrelated legacy workspace of the current directory.
#
# Pure read: runs `herdr workspace list` exactly once, creates/closes/renames
# nothing, no side effects beyond the returned label on stdout.
# Arguments:
#   $1 - candidate workspace label (new form, possibly with a trailing
#        /{branch_leaf})
# Returns: writes the label that exists (new form preferred) to stdout,
#          returns 1 if $1 is empty or neither form is present.
function hrd::internal::resolve_workspace_label {
  local candidate="$1"
  [[ -z "$candidate" ]] && return 1

  local labels
  labels="$(herdr workspace list 2>/dev/null \
    | jq -r '.result.workspaces[]?.label // empty')"
  [[ -z "$labels" ]] && return 1

  if printf '%s\n' "$labels" | grep -qFx "$candidate"; then
    printf '%s\n' "$candidate"
    return 0
  fi

  # Legacy fallback: split on the LAST slash, re-derive only the context part.
  local context="$candidate" leaf=""
  if [[ "$candidate" == */* ]]; then
    context="${candidate%/*}"
    leaf="${candidate##*/}"
  fi

  # Gate: the candidate's context must be what THIS directory currently
  # derives (with the map applied), otherwise it is an unrelated name and
  # the current directory's legacy workspace must not match it.
  [[ "$context" == "$(hrd::internal::derive_project_name "")" ]] || return 1

  local legacy_context legacy
  legacy_context="$(core::workspace::derive_name "" "")"
  [[ -z "$legacy_context" ]] && return 1
  if [[ -n "$leaf" ]]; then
    legacy="${legacy_context}/${leaf}"
  else
    legacy="$legacy_context"
  fi

  if printf '%s\n' "$labels" | grep -qFx "$legacy"; then
    printf '%s\n' "$legacy"
    return 0
  fi
  return 1
}

# Resolve workspace ID from a workspace label.
# Consumes the choke-point resolver, so whichever label exists (new or
# legacy) is the one fed to the jq select below — the legacy fallback can no
# longer half-land in one comparison site and miss the other (design Risk 4).
# Arguments:
#   $1 - workspace label
# Returns: writes workspace_id to stdout; empty output when nothing resolves
#          or when the label exists but carries no workspace_id (status 0,
#          matching the pre-choke-point jq-only behavior callers rely on),
#          returns 1 if $1 is empty.
function hrd::internal::resolve_workspace_id {
  local label="$1"
  [[ -z "$label" ]] && return 1

  local resolved
  resolved="$(hrd::internal::resolve_workspace_label "$label")" || resolved=""
  [[ -z "$resolved" ]] && return 0

  herdr workspace list 2>/dev/null \
    | jq -r --arg label "$resolved" '.result.workspaces[] | select(.label == $label) | .workspace_id // empty'
}

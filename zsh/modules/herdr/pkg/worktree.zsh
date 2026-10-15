# shellcheck shell=bash

# ──────────────────────────────────────────────
# Worktree helpers (hrdw::*)
# ──────────────────────────────────────────────

# hrdw::list — list all worktrees for the current repo.
function hrdw::list {
  if ! hrd::internal::worktree::is_git_repo; then
    message_error "Not a git repository: ${PWD}"
    return 1
  fi

  hrd::internal::worktree::list
}

# hrdw::create — create a git worktree from current directory.
# Usage: hrdw::create <branch-name>
#   If branch-name has no known prefix (feature/, fix/, bugfix/, hotfix/, chore/),
#   auto-prepend feature/.
# Examples:
#   hrdw::create RD-21     -> feature/RD-21
#   hrdw::create hotfix/x  -> hotfix/x (no prefix added)
function hrdw::create {
  if ! hrd::internal::worktree::is_git_repo; then
    message_error "Not a git repository: ${PWD}"
    return 1
  fi

  local name="${1:-}"
  if [[ -z "$name" ]]; then
    message_error "Usage: hrdw::create <branch-name>"
    return 1
  fi

  # Auto-prepend feature/ if no known prefix
  name="$(hrd::internal::worktree::ensure_branch_prefix "$name")"

  # Derive workspace label: <project-context>/<branch-name>
  local label
  label="$(hrd::internal::worktree::derive_label "$name")"

  # Check if worktree already exists for this branch
  if hrd::internal::worktree::branch_exists "$name"; then
    local existing_path
    existing_path="$(hrd::internal::worktree::resolve_path "$name")"
    message_info "Worktree '${label}' already exists at: ${existing_path}"
    printf 'Open it? (Y/n) '
    # shellcheck disable=SC2162
    read -q reply
    printf '\n'
    if [[ "$reply" =~ ^[Yy]$ ]] || [[ -z "$reply" ]]; then
      hrd::internal::worktree::open "$name"
    fi
    return 0
  fi

  if hrd::internal::worktree::create "$name" "$label"; then
    # Set up 3-pane IDE layout after successful worktree creation
    local ws_id
    ws_id="$(hrd::internal::resolve_workspace_id "$label")" || true
    if [[ -n "$ws_id" ]]; then
      hrd::internal::pane::setup_3_pane_layout "$ws_id" || true
    fi
  fi
}

# hrdw::open — open an existing worktree via fzf or by branch name.
# Usage:
#   hrdw::open         -> fzf selector
#   hrdw::open RD-21   -> resolves feature/RD-21 and opens it
function hrdw::open {
  if ! hrd::internal::worktree::is_git_repo; then
    message_error "Not a git repository: ${PWD}"
    return 1
  fi

  local target="${1:-}"

  if [[ -z "$target" ]]; then
    # fzf selector
    local selection
    selection="$(hrd::internal::worktree::fzf_select "Open worktree: ")" || return 1
    # Extract path (second field in "branch | path | status" format)
    local path
    path="$(printf '%s\n' "$selection" | awk -F ' \\| ' '{print $2}')"
    if [[ -n "$path" ]]; then
      hrd::internal::worktree::open "$path"
    fi
    return
  fi

  # Auto-prefix same as create
  target="$(hrd::internal::worktree::ensure_branch_prefix "$target")"

  # Derive context for display
  local label
  label="$(hrd::internal::worktree::derive_label "$target")"
  message_info "Opening worktree: ${label}"
  hrd::internal::worktree::open "$target"
}

# hrdw::remove — remove a worktree by workspace ID or via fzf.
# Usage:
#   hrdw::remove <workspace-id>   -> remove by ID
#   hrdw::remove                  -> fzf selector, then confirm, then remove
#   hrdw::remove <id> --force     -> force remove
function hrdw::remove {
  if ! hrd::internal::worktree::is_git_repo; then
    message_error "Not a git repository: ${PWD}"
    return 1
  fi

  local id="${1:-}"
  local force="${2:-}"

  if [[ -z "$id" ]]; then
    # fzf selector
    local selection
    selection="$(hrd::internal::worktree::fzf_select "Remove worktree: ")" || return 1
    # Extract branch (first field)
    local branch
    branch="$(printf '%s\n' "$selection" | awk -F ' \\| ' '{print $1}')"
    # Resolve workspace ID from branch
    local ws_id
    ws_id="$(hrd::internal::worktree::resolve_workspace_id "$branch")"
    if [[ -z "$ws_id" ]]; then
      message_error "Could not resolve workspace ID for branch: ${branch}"
      return 1
    fi
    local label
    label="$(hrd::internal::worktree::derive_label "$branch")"
    printf 'Remove worktree "%s" (workspace: %s)? (y/N) ' "$label" "$ws_id"
    # shellcheck disable=SC2162
    read -q reply
    printf '\n'
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      hrd::internal::worktree::remove "$ws_id" "$force"
    fi
    return
  fi

  hrd::internal::worktree::remove "$id" "$force"
}

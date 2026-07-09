# shellcheck shell=bash

# ──────────────────────────────────────────────
# Worktree helpers
# ──────────────────────────────────────────────

function hrd::internal::worktree::is_git_repo {
  git rev-parse --git-dir &>/dev/null
}

function hrd::internal::worktree::derive_repo_name {
  local remote
  remote="$(git remote get-url origin 2>/dev/null)"
  if [[ -n "$remote" ]]; then
    local repo
    repo="${remote##*/}"
    repo="${repo%.git}"
    printf '%s\n' "$repo"
  else
    basename "$(git rev-parse --show-toplevel 2>/dev/null)"
  fi
}

function hrd::internal::worktree::branch_exists {
  local branch="$1"
  [[ -z "$branch" ]] && return 1

  herdr worktree list --cwd . --json 2>/dev/null \
    | jq -e --arg branch "$branch" '.result.worktrees[] | select(.branch == $branch) | length > 0' &>/dev/null
}

function hrd::internal::worktree::list {
  local output
  output="$(herdr worktree list --cwd . --json 2>/dev/null \
    | jq -r '.result.worktrees[]? | "\(.branch) | \(.path)"' 2>/dev/null)"

  if [[ -z "$output" ]]; then
    message_info "No worktrees found for current repository."
    return 1
  fi

  printf '%s\n' "$output"
}

function hrd::internal::worktree::create {
  local branch="$1"
  local label="${2:-}"
  if [[ -z "$branch" ]]; then
    message_error "Usage: hrd::internal::worktree::create <branch-name> [label]"
    return 1
  fi

  if hrd::internal::worktree::branch_exists "$branch"; then
    message_error "Worktree already exists for branch: ${branch}"
    return 1
  fi

  local cmd=(herdr worktree create --cwd . --branch "$branch" --focus)
  if [[ -n "$label" ]]; then
    cmd+=(--label "$label")
  fi

  if "${cmd[@]}" 2>/dev/null; then
    message_success "Worktree '${label:-${branch}}' created and opened"
    return 0
  fi

  message_error "Failed to create worktree for branch: ${branch}"
  return 1
}

function hrd::internal::worktree::open {
  local target="$1"
  if [[ -z "$target" ]]; then
    message_error "Usage: hrd::internal::worktree::open <path|branch>"
    return 1
  fi

  # If it looks like a branch (no leading / or ~), resolve to path
  if [[ "$target" != /* ]] && [[ "$target" != ~* ]]; then
    local resolved
    resolved="$(hrd::internal::worktree::resolve_path "$target")"
    if [[ -n "$resolved" ]]; then
      target="$resolved"
    fi
  fi

  if herdr worktree open --path "$target" --focus 2>/dev/null; then
    return 0
  fi

  message_error "Failed to open worktree: ${target}"
  return 1
}

function hrd::internal::worktree::remove {
  local id="$1"
  local force_flag="$2"

  if [[ -z "$id" ]]; then
    message_error "Usage: hrd::internal::worktree::remove <workspace-id> [--force]"
    return 1
  fi

  local cmd=(herdr worktree remove --workspace "$id")
  if [[ "$force_flag" == "--force" ]]; then
    cmd+=(--force)
  fi

  if "${cmd[@]}" 2>/dev/null; then
    message_success "Worktree removed (workspace: ${id})"
    return 0
  fi

  local error_output
  error_output="$("${cmd[@]}" 2>&1)" || true
  if [[ "$error_output" == *"dirty"* ]] || [[ "$error_output" == *"uncommitted"* ]]; then
    message_warning "Worktree has uncommitted changes. Use --force to remove anyway."
  fi

  message_error "Failed to remove worktree (workspace: ${id})"
  return 1
}

function hrd::internal::worktree::fzf_select {
  local prompt="${1:-Select worktree: }"

  local worktrees
  worktrees="$(hrd::internal::worktree::list 2>/dev/null)" || {
    message_info "No worktrees available."
    return 1
  }

  local selection
  selection="$(
    printf '%s\n' "$worktrees" \
      | hrd::internal::fzf_select "$prompt" "ls -la {3}"
  )"

  [[ -n "$selection" ]] && printf '%s\n' "$selection"
}

# Resolve worktree path from a branch name.
# Arguments:
#   $1 - branch name
# Returns: writes path to stdout, empty if not found.
function hrd::internal::worktree::resolve_path {
  local branch="$1"
  [[ -z "$branch" ]] && return 1
  herdr worktree list --cwd . --json 2>/dev/null \
    | jq -r --arg branch "$branch" '.result.worktrees[] | select(.branch == $branch) | .path // empty'
}

# Resolve open workspace ID from a branch name.
# Arguments:
#   $1 - branch name
# Returns: writes open_workspace_id to stdout, empty if not found.
function hrd::internal::worktree::resolve_workspace_id {
  local branch="$1"
  [[ -z "$branch" ]] && return 1
  herdr worktree list --cwd . --json 2>/dev/null \
    | jq -r --arg branch "$branch" '.result.worktrees[] | select(.branch == $branch) | .open_workspace_id // empty'
}

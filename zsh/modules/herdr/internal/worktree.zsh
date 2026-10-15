# shellcheck shell=bash

# ──────────────────────────────────────────────
# Worktree helpers
# ──────────────────────────────────────────────

function hrd::internal::worktree::is_git_repo {
  git rev-parse --git-dir &>/dev/null
}

# Ensure a branch name carries a known git-flow prefix.
# The single source for the prefix chain (feature/, fix/, bugfix/, hotfix/,
# chore/) previously duplicated in hrdw::create and hrdw::open (design D4).
# Arguments:
#   $1 - branch name (with or without a known git-flow prefix)
# Returns: writes the prefixed branch name to stdout — feature/ prepended
#          when the branch matches none of the known prefixes.
function hrd::internal::worktree::ensure_branch_prefix {
  local branch="$1"
  if [[ "$branch" != feature/* ]] \
    && [[ "$branch" != fix/* ]] \
    && [[ "$branch" != bugfix/* ]] \
    && [[ "$branch" != hotfix/* ]] \
    && [[ "$branch" != chore/* ]]; then
    branch="feature/${branch}"
  fi
  printf '%s\n' "$branch"
}

# Derive the worktree label "{project_context}/{branch_leaf}" for a branch.
# The single source for the label assembly previously duplicated in
# hrdw::create, hrdw::open and hrdw::remove (design D4), making label parity
# a structural guarantee instead of a discipline three call sites maintain
# by hand. The label CONTAINS A SLASH: it is assembled verbatim here and
# never slugified; only the branch leaf (text after the branch's LAST slash)
# is extracted, exactly what the three call sites did. The project context
# comes from hrd::internal::derive_project_name with the 2>/dev/null +
# ${PWD:t} fallback form two of the three call sites used — the derivation
# always exits 0 and writes nothing to stderr, so the fallback is defensive.
# Arguments:
#   $1 - branch name (e.g. feature/RD-21)
# Returns: writes "<project_context>/<branch_leaf>" to stdout.
function hrd::internal::worktree::derive_label {
  local branch="$1"
  local project_context
  project_context="$(hrd::internal::derive_project_name 2>/dev/null || printf '%s\n' "${PWD:t}")"
  local branch_part="${branch##*/}"
  printf '%s\n' "${project_context}/${branch_part}"
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

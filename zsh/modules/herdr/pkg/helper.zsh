# shellcheck shell=bash

# ──────────────────────────────────────────────
# Workspace helpers (hrd / hrdk)
# ──────────────────────────────────────────────

# Wrapper for herdr command, with optional TMUX-like socket support.
_hrd() {
  command herdr "$@"
}

# hrd — switch or create herdr workspace via fzf.
# Port of ftm (fuzzy tmux) from the tmux module.
# Without arguments: list workspaces via fzf, switch to selected.
# With argument that matches a known subcommand: forward to _hrd.
# With other argument: switch to named workspace (create if missing).
function hrd {
  if [[ $# -eq 0 ]]; then
    local workspaces
    workspaces="$(hrd::internal::list_workspaces 2>/dev/null)" || {
      message_info "No herdr workspaces found. Create one with: herdr workspace create --label <name>"
      return 1
    }

    local selection
    selection="$(
      printf '%s\n' "$workspaces" \
        | hrd::internal::fzf_select "Switch workspace: "
    )"

    if [[ -n "$selection" ]]; then
      hrd::internal::switch_workspace "$selection"
    fi
    return
  fi

  # Known herdr subcommands — forward to _hrd()
  case "$1" in
    workspace|session|server|plugin|worktree|completion|update|status|api|tab|pane|agent|wait|notification|integration|terminal)
      _hrd "$@"
      ;;
    *)
      hrd::internal::switch_workspace "$1"
      ;;
  esac
}

# hrdk — kill a herdr workspace via fzf.
# Port of ftmk (fuzzy tmux kill) from the tmux module.
# Without arguments: list workspaces via fzf, kill selected.
# With argument: kill named workspace.
function hrdk {
  if [[ -n "${1}" ]]; then
    hrd::internal::kill_workspace "${1}"
    return
  fi

  local workspaces
  workspaces="$(hrd::internal::list_workspaces 2>/dev/null)" || {
    message_info "No herdr workspaces found."
    return 1
  }

  local selection
  selection="$(
    printf '%s\n' "$workspaces" \
      | hrd::internal::fzf_select "Kill workspace: "
  )"

  if [[ -n "$selection" ]]; then
    hrd::internal::kill_workspace "$selection"
  fi
}

# ──────────────────────────────────────────────
# Project launcher
# ──────────────────────────────────────────────

# hrd::project — create a herdr workspace with 3-pane IDE layout.
# Port of tx::project from the tmux module.
# Without arguments: derives project name from directory context.
# With argument: use provided project name.
function hrd::project {
  local project_name
  project_name="$(hrd::internal::derive_project_name "${1:-}")"

  if [[ -z "${project_name}" ]]; then
    message_error "Could not determine a valid project name."
    return 1
  fi

  # If workspace already exists, prompt to attach (or decline)
  if hrd::internal::workspace_attach_or_create "$project_name"; then
    return 0
  fi

  # Create workspace with focus in pane 1; capture workspace_id for rename
  local ws_json ws_id
  ws_json="$(herdr workspace create --label "$project_name" --cwd "$PWD" --focus 2>/dev/null)" || {
    message_error "Failed to create workspace '${project_name}'."
    return 1
  }
  ws_id="$(printf '%s\n' "$ws_json" | jq -r '.result.workspace.workspace_id')"

  # Set up 3-pane IDE layout via shared helper
  hrd::internal::pane::setup_3_pane_layout "$ws_id"

  message_success "Project workspace '${project_name}' created."
}

# ──────────────────────────────────────────────
# Config editor helpers
# ──────────────────────────────────────────────

# edit-herdr-config — open herdr config.toml in $EDITOR.
# Port of edittmux from the tmux module.
function edit-herdr-config {
    if [[ -z "${EDITOR}" ]]; then
        message_warning "EDITOR is not set."
        return 1
    fi

    local config_file="${ZSH_HERDR_CONFIG_DIR}/config.toml"

    if [[ ! -f "$config_file" ]]; then
        message_warning "Config file not found: $config_file"
        return 1
    fi

    "${EDITOR}" "$config_file"
}

# edit-herdr-plugins — open herdr plugins directory in $EDITOR.
function edit-herdr-plugins {
    if [[ -z "${EDITOR}" ]]; then
        message_warning "EDITOR is not set."
        return 1
    fi

    local plugins_dir="${ZSH_HERDR_CONFIG_DIR}/plugins"

    if [[ ! -d "$plugins_dir" ]]; then
        message_warning "Plugins directory not found: $plugins_dir"
        return 1
    fi

    "${EDITOR}" "$plugins_dir"
}

# ──────────────────────────────────────────────
# Plugin management (interactive)
# ──────────────────────────────────────────────

# hrd::plugin — interactive plugin management via fzf.
# Follows the same pattern as hrd (workspace switch) and hrdk (workspace kill).
# Without arguments: presents an fzf selector with actions.
# With argument "install|list|update|uninstall": executes that action directly.
function hrd::plugin {
    local action="${1:-}"

    # Ensure fzf is available for interactive mode
    if [[ -z "$action" ]]; then
        if ! core::exists fzf; then
            message_error "fzf is required for interactive mode."
            return 1
        fi

        action="$(
            printf '%s\n' "install" "list" "update" "uninstall" \
                | hrd::internal::fzf_select "Plugin action: "
        )" || return 1
    fi

    case "$action" in
        install)
            herdr::internal::plugin::install::all
            ;;
        list)
            herdr::internal::plugin::list
            ;;
        update)
            herdr::internal::plugin::update::all
            ;;
        uninstall)
            local installed
            installed="$(herdr plugin list 2>/dev/null)" || {
                message_error "Failed to list installed plugins."
                return 1
            }

            if [[ -z "$installed" ]]; then
                message_info "No plugins installed."
                return 0
            fi

            local selection
            selection="$(
                printf '%s\n' "$installed" \
                    | hrd::internal::fzf_select "Select plugin to uninstall: "
            )"

            if [[ -n "$selection" ]]; then
                herdr::internal::plugin::uninstall "$selection"
            fi
            ;;
        *)
            message_error "Unknown action: $action. Use install, list, update, or uninstall."
            return 1
            ;;
    esac
}

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
  if [[ "$name" != feature/* ]] \
    && [[ "$name" != fix/* ]] \
    && [[ "$name" != bugfix/* ]] \
    && [[ "$name" != hotfix/* ]] \
    && [[ "$name" != chore/* ]]; then
    name="feature/${name}"
  fi

  # Derive workspace label: <project-context>/<branch-name>
  local project_context
  project_context="$(hrd::internal::derive_project_name)" || project_context="${PWD:t}"
  local branch_part="${name##*/}"
  local label="${project_context}/${branch_part}"

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
  if [[ "$target" != feature/* ]] \
    && [[ "$target" != fix/* ]] \
    && [[ "$target" != bugfix/* ]] \
    && [[ "$target" != hotfix/* ]] \
    && [[ "$target" != chore/* ]]; then
    target="feature/${target}"
  fi

  # Derive context for display
  local project_context
  project_context="$(hrd::internal::derive_project_name 2>/dev/null || printf '%s\n' "${PWD:t}")"
  local branch_part="${target##*/}"
  message_info "Opening worktree: ${project_context}/${branch_part}"
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
    local project_context
    project_context="$(hrd::internal::derive_project_name 2>/dev/null || printf '%s\n' "${PWD:t}")"
    local branch_part="${branch##*/}"
    printf 'Remove worktree "%s/%s" (workspace: %s)? (y/N) ' "$project_context" "$branch_part" "$ws_id"
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

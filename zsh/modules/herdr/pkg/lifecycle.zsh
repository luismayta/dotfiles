# shellcheck shell=bash

# ──────────────────────────────────────────────
# Workspace helpers (hrd / hrdk)
# ──────────────────────────────────────────────

# Wrapper for the herdr command: forwards all arguments to `herdr`.
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

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

# Derive a project name from an argument or directory context.
# If $1 is given, it is used as the project name (sanitized).
# If $1 is omitted, derives from $PWD and $HOME:
#   $PWD == $HOME           -> "core"
#   parent == $HOME         -> "core-{current_dir}"
#   otherwise               -> "{parent_dir}-{current_dir}"
# Returns: writes project name to stdout.
function hrd::internal::derive_project_name {
  local name

  if [[ -n "$1" ]]; then
    name="$1"
  else
    local current_dir="${PWD:t}"
    local parent_dir="${PWD:h:t}"

    if [[ "$PWD" == "$HOME" ]]; then
      name="core"
    elif [[ "${PWD:h}" == "$HOME" ]]; then
      name="core-${current_dir}"
    else
      name="${parent_dir}-${current_dir}"
    fi
  fi

  # Slug: replace non-alphanumeric chars with hyphen, collapse, lowercase
  name="${name//[^a-zA-Z0-9]/-}"
  while [[ "$name" == *--* ]]; do name="${name//--/-}"; done
  name="${name#-}"
  name="${name%-}"
  name="${name:l}"

  printf '%s\n' "$name"
}

# List project template names (without .toml extension) from
# ZSH_HERDR_PROJECT_TEMPLATE_PATH, one per line.
# Uses fd if available, falls back to zsh glob.
# Returns: writes template names to stdout, one per line.
function hrd::internal::list_templates {
  local template_dir="${ZSH_HERDR_PROJECT_TEMPLATE_PATH}"

  if [[ ! -d "$template_dir" ]]; then
    return 1
  fi

  local files
  if (( ${+commands[fd]} )); then
    # shellcheck disable=SC2296
    files=("${(@f)$(fd -e toml --max-depth 1 . "$template_dir" 2>/dev/null)}")
  else
    # shellcheck disable=SC1036
    files=("$template_dir"/*.toml(N))
  fi

  local f
  for f in "${files[@]}"; do
    printf '%s\n' "${f:r:t}"
  done
}

# Interactively select a project template using fzf with preview.
# Falls back to "default" on cancel.
# Returns: writes selected template name to stdout.
function hrd::internal::select_template {
  local template_dir="${ZSH_HERDR_PROJECT_TEMPLATE_PATH}"

  if [[ ! -d "$template_dir" ]]; then
    message_error "Template directory not found: $template_dir"
    return 1
  fi

  local selection
  selection="$(
    hrd::internal::list_templates \
      | hrd::internal::fzf_select \
          "Select project template: " \
          "bat --language=toml --color=always $template_dir/{}.toml 2>/dev/null || cat -n $template_dir/{}.toml"
  )"

  if [[ -z "$selection" ]]; then
    printf '%s\n' "default"
  else
    printf '%s\n' "$selection"
  fi
}

# Resolve workspace ID from a workspace label.
# Arguments:
#   $1 - workspace label
# Returns: writes workspace_id to stdout, returns 1 if not found.
function hrd::internal::resolve_workspace_id {
  local label="$1"
  [[ -z "$label" ]] && return 1
  herdr workspace list 2>/dev/null \
    | jq -r --arg label "$label" '.result.workspaces[] | select(.label == $label) | .workspace_id // empty'
}

# shellcheck shell=bash

# ──────────────────────────────────────────────
# Install helpers
# ──────────────────────────────────────────────

function herdr::internal::install {
    if core::exists herdr; then
        message_info "${ZSH_HERDR_PACKAGE_NAME} is already installed."
        return 0
    fi

    core::ensure curl

    message_info "Installing ${ZSH_HERDR_PACKAGE_NAME}..."
    if curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh; then
        if core::exists herdr; then
            message_success "${ZSH_HERDR_PACKAGE_NAME} installed successfully"
            return 0
        fi
        message_warning "${ZSH_HERDR_PACKAGE_NAME} install script ran but binary not found in PATH"
    fi

    message_error "Failed to install ${ZSH_HERDR_PACKAGE_NAME}"
    return 1
}

function herdr::internal::config::sync {
    local src="${ZSH_HERDR_DATA_PATH}"
    local dst="${ZSH_HERDR_CONFIG_DIR}"

    if [[ ! -d "$src" ]] || [[ -z "$(ls -A "$src" 2>/dev/null)" ]]; then
        message_info "No ${ZSH_HERDR_PACKAGE_NAME} config found in data path"
        return 0
    fi

    mkdir -p "$dst"
    message_info "Syncing ${ZSH_HERDR_PACKAGE_NAME} config..."

    if rsync -avzh "$src/" "$dst/"; then
        message_success "${ZSH_HERDR_PACKAGE_NAME} config synced successfully"
    else
        message_error "Failed to sync ${ZSH_HERDR_PACKAGE_NAME} config"
        return 1
    fi
}

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
        workspace_id="$(herdr workspace list 2>/dev/null | jq -r --arg label "$name" '.result.workspaces[] | select(.label == $label) | .workspace_id // empty')" || return 1

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
    workspace_id="$(herdr workspace list 2>/dev/null | jq -r --arg label "$name" '.result.workspaces[] | select(.label == $label) | .workspace_id // empty')" || return 1

    if [[ -z "$workspace_id" ]]; then
        message_error "Workspace '${name}' not found."
        return 1
    fi

    herdr workspace close "$workspace_id" 2>/dev/null && return 0
    return 1
}

# ──────────────────────────────────────────────
# FZF helpers
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

# ──────────────────────────────────────────────
# Project / Template helpers
# ──────────────────────────────────────────────

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
# ──────────────────────────────────────────────
# Plugin helpers
# ──────────────────────────────────────────────

function herdr::internal::plugin::install {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::install <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if herdr plugin install "$plugin" --yes; then
    message_success "Plugin '$plugin' installed"
  else
    message_error "Failed to install plugin '$plugin'"
  fi
}

function herdr::internal::plugin::install::all {
  if [[ "$ZSH_HERDR_PLUGIN_ENABLED" != true ]]; then
    message_info "Plugin management is disabled (ZSH_HERDR_PLUGIN_ENABLED != true)"
    return 0
  fi

  if [[ ${#ZSH_HERDR_INSTALL_PLUGINS[@]} -eq 0 ]]; then
    message_info "No plugins defined in ZSH_HERDR_INSTALL_PLUGINS"
    return 0
  fi

  for plugin in "${ZSH_HERDR_INSTALL_PLUGINS[@]}"; do
    if herdr plugin list 2>/dev/null | grep -qFx "$plugin"; then
      message_info "Plugin '$plugin' already installed, skipping"
    else
      herdr::internal::plugin::install "$plugin"
    fi
  done
}

function herdr::internal::plugin::list {
  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  local output
  output="$(herdr plugin list 2>/dev/null)"

  if [[ -z "$output" ]]; then
    message_info "No plugins installed"
    return 0
  fi

  printf '%s\n' "$output"
}

function herdr::internal::plugin::update {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::update <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if herdr plugin install "$plugin" --yes; then
    message_success "Plugin '$plugin' updated"
  else
    message_error "Failed to update plugin '$plugin'"
  fi
}

function herdr::internal::plugin::update::all {
  if [[ ${#ZSH_HERDR_INSTALL_PLUGINS[@]} -eq 0 ]]; then
    message_info "No plugins defined in ZSH_HERDR_INSTALL_PLUGINS"
    return 0
  fi

  for plugin in "${ZSH_HERDR_INSTALL_PLUGINS[@]}"; do
    herdr::internal::plugin::update "$plugin"
  done
}

function herdr::internal::plugin::uninstall {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::uninstall <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if ! herdr plugin list 2>/dev/null | grep -qFx "$plugin"; then
    message_warning "Plugin '$plugin' is not installed"
    return 0
  fi

  if herdr plugin uninstall "$plugin"; then
    message_success "Plugin '$plugin' uninstalled"
  else
    message_error "Failed to uninstall plugin '$plugin'"
  fi
}

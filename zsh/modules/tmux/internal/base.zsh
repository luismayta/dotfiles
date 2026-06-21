# shellcheck shell=bash

function tmux::internal::tmux::install {
    message_info "Installing ${TMUX_PACKAGE_NAME}"
    core::install tmux
    message_success "Installed ${TMUX_PACKAGE_NAME}"
    tmux::post_install
}

function tmux::internal::tmuxinator::install {
    message_info "Installing tmuxinator for ${TMUX_PACKAGE_NAME}"
    if ! core::exists gem; then
        message_warning "${CORE_MESSAGE_RVM}"
        return
    fi
    gem install tmuxinator
    message_success "Installed tmuxinator for ${TMUX_PACKAGE_NAME}"
}

function tmux::internal::tpm::install {
    message_info "Installing tpm for ${TMUX_PACKAGE_NAME}"
    git clone "${TMUX_INSTALL_URL_TPM}" "${TMUX_TPM_PATH}"
    message_success "Installed tpm for ${TMUX_PACKAGE_NAME}"
}

#
# Derives a tmuxinator project name from an argument or directory context.
#
# If $1 is given, it is used as the project name (sanitized).
# If $1 is omitted, the name is derived from $PWD and $HOME:
#   $PWD == $HOME          -> "core"
#   parent == $HOME        -> "core-{current_dir}"
#   otherwise              -> "{parent_dir}-{current_dir}"
#
# Returns: writes project name to stdout; exit code always 0.
#
tx::internal::derive_project_name() {
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

  # Slug: replace any run of non-alphanumeric chars with a single hyphen,
  # strip leading/trailing hyphens, then lowercase.
  name="${name//[^a-zA-Z0-9]/-}"
  while [[ "$name" == *--* ]]; do name="${name//--/-}"; done
  name="${name#-}"
  name="${name%-}"
  name="${name:l}"

  printf '%s\n' "$name"
}

#
# Returns a command string for fzf --preview to render a template YAML file.
#
# Uses bat if available, falls back to cat -n.
#
# Returns: writes the preview command string to stdout; exit code always 0.
#
tx::internal::preview_command() {
  if (( ${+commands[bat]} )); then
    printf '%s\n' 'bat --language=yaml --color=always {}'
  else
    printf '%s\n' 'cat -n {}'
  fi
}

#
# Lists tmuxinator template names (without .yml extension) from
# TMUXINATOR_TEMPLATE_PATH, one per line.
#
# Uses fd if available, falls back to zsh glob.
#
# Returns: writes template names to stdout (one per line); exit code always 0.
#
tx::internal::list_templates() {
  local template_dir="${TMUXINATOR_TEMPLATE_PATH:-$HOME/.tmuxinator}"
  local files

  if (( ${+commands[fd]} )); then
    # shellcheck disable=SC2296
    files=("${(@f)$(fd -e yml --max-depth 1 . "$template_dir" 2>/dev/null)}")
  else
    # shellcheck disable=SC1036
    files=("$template_dir"/*.yml(N))
  fi

  local f
  for f in "${files[@]}"; do
    printf '%s\n' "${f:r:t}"
  done
}

#
# Interactively selects a tmuxinator template using fzf with preview.
# Falls back to TMUXINATOR_DEFAULT_TEMPLATE on cancel.
#
# Returns: writes selected template name to stdout; exit code always 0.
#
tx::internal::select_template() {
  local preview_cmd
  preview_cmd="$(tx::internal::preview_command)"

  local selection
  selection="$(
    tx::internal::list_templates \
      | fzf --preview "$preview_cmd" --preview-window=right:60% \
            --prompt='Select tmuxinator template: '
  )"

  if [[ -z "$selection" ]]; then
    printf '%s\n' "${TMUXINATOR_DEFAULT_TEMPLATE:-tmuxinator-default}"
  else
    printf '%s\n' "$selection"
  fi
}

#
# Checks if a tmux session already exists. If yes, prompts the user
# to attach and handles it.
#
# Returns:
#   0 if session existed (user attached or declined; caller should stop)
#   1 if session does not exist (caller should continue to create)
#
tx::internal::attach_if_exists() {
  local session_name="$1"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    printf 'A tmux session "%s" already exists. ' "$session_name"
    # shellcheck disable=SC2162
    read -q "?Attach? (Y/n) "
    printf '\n'
    if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]]; then
      tmux attach-session -t "$session_name"
    fi
    return 0
  fi

  return 1
}
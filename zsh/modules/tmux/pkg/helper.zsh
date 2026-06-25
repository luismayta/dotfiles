# shellcheck shell=bash

# edittmux edit settings for tmux
function edittmux {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${TMUX_FILE_SETTINGS}"
}

# tx::project [name project].
# Description: Select a tmuxinator template interactively with fzf and start a new project session.
function tx::project {
  if ! core::exists tmuxinator; then
    message_error "tmuxinator is not installed."
    return 1
  fi

  if [[ ! -d "${TMUXINATOR_TEMPLATE_PATH}" ]]; then
    message_error "Templates directory not found: ${TMUXINATOR_TEMPLATE_PATH}"
    return 1
  fi

  local selected_template
  selected_template="$(tx::internal::select_template)"

  local project_name
  project_name="$(tx::internal::derive_project_name "${1:-}")"

  if [[ -z "${project_name}" ]]; then
    message_error "Could not determine a valid project name."
    return 1
  fi

  tx::internal::attach_if_exists "${project_name}" && return

  message_info "Launching tmuxinator project '${project_name}' with template '${selected_template}'..."
  if tmuxinator start "${selected_template}" "${project_name}"; then
    message_info "Project '${project_name}' started successfully."
  else
    message_error "Failed to start project '${project_name}' with template '${selected_template}'."
    return 1
  fi
}

# Use TMUX_SOCKET when outside tmux (e.g., ghostty/wezterm terminal-specific sockets)
_tmux() {
  if [[ -z "${TMUX}" && -n "${TMUX_SOCKET:-}" ]]; then
    command tmux -L "${TMUX_SOCKET}" "$@"
  else
    command tmux "$@"
  fi
}

# ftm — create or switch tmux session via fzf
ftm() {
  local change="attach-session"
  [[ -n "${TMUX}" ]] && change="switch-client"

  if [ -n "${1}" ]; then
    _tmux "${change}" -t "${1}" 2>/dev/null \
      || (_tmux new-session -d -s "${1}" && _tmux "${change}" -t "${1}")
    return
  fi
  local session
  session="$(_tmux list-sessions -F '#{session_name}' 2>/dev/null | fzf --exit-0)" \
    && _tmux "${change}" -t "${session}" \
    || echo "No sessions found."
}

# ftmk — kill a tmux session via fzf
ftmk() {
  if [ -n "${1}" ]; then
    _tmux kill-session -t "${1}"
    return
  fi
  local session
  session="$(_tmux list-sessions -F '#{session_name}' 2>/dev/null \
    | fzf --exit-0)" \
    && _tmux kill-session -t "${session}" \
    || echo "No session found to delete."
}


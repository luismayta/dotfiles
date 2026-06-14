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
  local selected_template project_name sanitized_name preview_cmd template

  if ! core::exists tmuxinator; then
    message_error "tmuxinator is not installed."
    return 1
  fi

  # Validate template directory exists
  if [[ ! -d "${TMUXINATOR_TEMPLATE_PATH}" ]]; then
    message_error "Templates directory not found: ${TMUXINATOR_TEMPLATE_PATH}"
    return 1
  fi

  # List all yml templates
  local templates=()
  if core::exists fd; then
    while IFS= read -r template; do
      templates+=("$(basename -s .yml "${template}")")
    done < <(fd -e yml . "${TMUXINATOR_TEMPLATE_PATH}" --max-depth 1)
  else
    for template in "${TMUXINATOR_TEMPLATE_PATH}"/*.yml; do
      [[ -f "${template}" ]] && templates+=("$(basename -s .yml "${template}")")
    done
  fi

  if (( ${#templates[@]} == 0 )); then
    message_warning "No templates found in ${TMUXINATOR_TEMPLATE_PATH}"
    return 1
  fi

  # Determine preview command
  if core::exists bat; then
    preview_cmd="bat --language=yaml --color=always '${TMUXINATOR_TEMPLATE_PATH}/{}.yml'"
  else
    preview_cmd="cat -n '${TMUXINATOR_TEMPLATE_PATH}/{}.yml'"
  fi

  selected_template=$(printf '%s\n' "${templates[@]}" \
    | fzf --prompt="Select tmuxinator template: " \
          --preview "${preview_cmd}") || selected_template="${TMUXINATOR_DEFAULT_TEMPLATE}"

  # Sanitize project name
  project_name=${1:-$(basename "$PWD")}
  sanitized_name=$(echo "${project_name}" \
    | sed 's/[^a-zA-Z0-9_-]/_/g; s/__*/_/g; s/^_//; s/_$//')

  if [[ -z "${sanitized_name}" ]]; then
    message_error "Could not determine a valid project name."
    return 1
  fi

  # Check if session already exists
  if tmux has-session -t "${sanitized_name}" 2>/dev/null; then
    message_warning "Session '${sanitized_name}' already exists."
    echo -n "Attach to existing session? [Y/n]: "
    read -r reply
    if [[ "${reply}" =~ ^[Yy]?$ ]]; then
      tmux attach-session -t "${sanitized_name}"
    fi
    return 0
  fi

  message_info "Launching tmuxinator project '${sanitized_name}' with template '${selected_template}'..."
  if tmuxinator start "${selected_template}" "${sanitized_name}"; then
    message_info "Project '${sanitized_name}' started successfully."
  else
    message_error "Failed to start project '${sanitized_name}' with template '${selected_template}'."
    return 1
  fi
}

# ftm — create or switch tmux session via fzf
ftm() {
  local change="attach-session"
  [[ -n "${TMUX}" ]] && change="switch-client"
  if [ -n "${1}" ]; then
    tmux "${change}" -t "${1}" 2>/dev/null \
      || (tmux new-session -d -s "${1}" && tmux "${change}" -t "${1}")
    return
  fi
  local session
  session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null | fzf --exit-0)" \
    && tmux "${change}" -t "${session}" \
    || echo "No sessions found."
}

# ftmk — kill a tmux session via fzf
ftmk() {
  if [ -n "${1}" ]; then
    tmux kill-session -t "${1}"
    return
  fi
  local session
  session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null \
    | fzf --exit-0)" \
    && tmux kill-session -t "${session}" \
    || echo "No session found to delete."
}


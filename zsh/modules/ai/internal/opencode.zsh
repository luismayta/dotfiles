# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${ZSH_AI_OPENCODE_BIN_PATH}" ] && export PATH="${ZSH_AI_OPENCODE_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::opencode::install {
    if core::exists opencode; then
        return 0
    fi

    message_info "Installing opencode..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_OPENCODE}" | bash; then
        message_success "opencode installed successfully"
    else
        message_error "Failed to install opencode"
        return 1
    fi
}

function ai::internal::opencode::sync {
    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    message_info "Syncing opencode config from ${ZSH_AI_OPENCODE_CONFIG_SOURCE_PATH} to ${ZSH_AI_OPENCODE_CONFIG_PATH}..."

    mkdir -p "${ZSH_AI_OPENCODE_CONFIG_PATH}"

    rsync -avzh --progress "${ZSH_AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${ZSH_AI_OPENCODE_CONFIG_PATH}/"

}

# === MCP Lifecycle ===
# Exposed reply variables set by _lookup (global, documented here):
#   _mcp_type      - "local" or "remote"
#   _mcp_command   - space-joined command string
#   _mcp_env       - space-joined "KEY=VALUE" entries
#   _mcp_url       - URL for remote servers (empty for local)
#   _mcp_disabled  - "true" or "false"

# 2.1: Resolve a server's metadata from the central config arrays.
function ai::internal::opencode::mcp::_lookup {
    local name="${1}"
    if [[ -z "${name}" ]]; then
        message_error "Usage: ai::internal::opencode::mcp::_lookup <name>"
        return 1
    fi

    # Check name exists in the canonical list
    local found=0
    local n
    for n in "${ZSH_AI_OPENCODE_MCP_NAMES[@]}"; do
        if [[ "${n}" == "${name}" ]]; then
            found=1
            break
        fi
    done

    if (( ! found )); then
        message_error "Unknown MCP server: ${name}"
        return 1
    fi

    # Find actual key (config may use quoted keys in zsh)
    local actual_key=""
    local k
    # shellcheck disable=SC2066,SC2296 # zsh array expansion (@k) and (P) syntax not supported by shellcheck
    for k in "${(@k)ZSH_AI_OPENCODE_MCP_TYPE}"; do
        local stripped="${k#\"}"
        stripped="${stripped%\"}"
        if [[ "${stripped}" == "${name}" ]]; then
            actual_key="${k}"
            break
        fi
    done
    [[ -z "${actual_key}" ]] && actual_key="${name}"

    typeset -g _mcp_type="${ZSH_AI_OPENCODE_MCP_TYPE[${actual_key}]}"
    typeset -g _mcp_command="${ZSH_AI_OPENCODE_MCP_COMMAND[${actual_key}]}"
    typeset -g _mcp_env="${ZSH_AI_OPENCODE_MCP_ENV[${actual_key}]}"
    typeset -g _mcp_url="${ZSH_AI_OPENCODE_MCP_URL[${actual_key}]:-}"
    typeset -g _mcp_disabled="${ZSH_AI_OPENCODE_MCP_DISABLED[${actual_key}]}"

    return 0
}

# Helper: substitute {env:VAR} placeholders in a string.
# Sets the global _mcp_substituted with the result.
function ai::internal::opencode::mcp::_substitute {
    local input="${1}"
    local result="${input}"
    local changed=1
    local var_name var_value

    while (( changed )); do
        changed=0
        if [[ "${result}" == *"{env:"*"}"* ]]; then
            var_name="${result#*{env:}"
            var_name="${var_name%%\}*}"
            
            # Security: Validate var_name is a valid environment variable name
            if [[ ! "${var_name}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
                message_warning "Invalid environment variable name in placeholder: {env:${var_name}}"
                # Leave placeholder intact
                continue
            fi
            
            # Check if var_name is a defined environment variable (exported)
            # ${parameters[$var_name]} returns e.g. "scalar-export" for exported vars
            # shellcheck disable=SC2154,SC2296 # parameters is a zsh builtin; (P) syntax not supported by shellcheck
            if [[ -v "${var_name}" && "${parameters[$var_name]}" == *export* ]]; then
                var_value="${(P)var_name}"
            else
                message_warning "Environment variable ${var_name} does not exist or is not exported; leaving placeholder intact"
                # Leave placeholder intact
                continue
            fi
            
            if [[ -z "${var_value}" ]]; then
                message_warning "Environment variable ${var_name} is empty"
            fi
            local new="${result//\{env:${var_name}\}/${var_value}}"
            if [[ "${new}" != "${result}" ]]; then
                result="${new}"
                changed=1
            fi
        fi
    done

    typeset -g _mcp_substituted="${result}"
}

# 2.2/2.3: Validate an MCP server by actually starting its command.
function ai::internal::opencode::mcp::validate {
    local force=0
    local name=""

    if [[ "${1}" == "--force" ]]; then
        force=1
        name="${2}"
    elif [[ "${2}" == "--force" ]]; then
        force=1
        name="${1}"
    else
        name="${1}"
    fi

    if [[ -z "${name}" ]]; then
        message_error "Usage: ai::internal::opencode::mcp::validate <name> [--force]"
        return 1
    fi

    if ! ai::internal::opencode::mcp::_lookup "${name}"; then
        return 1
    fi

    # Remote or empty command → skip
    if [[ "${_mcp_type}" == "remote" || -z "${_mcp_command}" ]]; then
        if [[ "${_mcp_type}" == "remote" ]]; then
            message_info "Skipping remote MCP ${name} (no local command)"
        else
            message_warning "Skipping local MCP ${name}: empty command"
        fi
        return 0
    fi

    # Disabled check
    if [[ "${_mcp_disabled}" == "true" && ${force} -eq 0 ]]; then
        message_warning "${name} is disabled. Use --force to validate anyway."
        return 1
    fi

    # Dispatch by first token
    local -a cmd_tokens
    # shellcheck disable=SC2206 # zsh = expansion not supported by shellcheck
    cmd_tokens=(${=_mcp_command})
    local runner="${cmd_tokens[1]}"

    case "${runner}" in
        uvx|bunx|npx)
            if ! core::exists "${runner}"; then
                message_error "${runner} is not installed"
                return 1
            fi
            ;;
        docker)
            if ! core::exists docker; then
                message_error "docker is not installed"
                return 1
            fi
            ;;
        /*)
            if [[ ! -x "${runner}" ]]; then
                message_error "Binary not found or not executable: ${runner}"
                return 1
            fi
            ;;
        *)
            if ! core::exists "${runner}"; then
                message_error "Binary not found: ${runner}"
                return 1
            fi
            ;;
    esac

    # Substitute {env:VAR} placeholders in command tokens
    local -a final_cmd
    # shellcheck disable=SC2034 # used as variable name for global _mcp_substituted
    local token substituted
    for token in "${cmd_tokens[@]}"; do
        ai::internal::opencode::mcp::_substitute "${token}"
        final_cmd+=("${_mcp_substituted}")
    done
    # shellcheck disable=SC2034 # used as variable name for global _mcp_substituted

    # Prepare environment variables from _mcp_env
    local -a env_vars=()
    if [[ -n "${_mcp_env}" ]]; then
        local -a env_tokens
        # shellcheck disable=SC2206 # zsh = expansion not supported by shellcheck
        env_tokens=(${=_mcp_env})
        local entry key value
        for entry in "${env_tokens[@]}"; do
            key="${entry%%=*}"
            value="${entry#*=}"
            ai::internal::opencode::mcp::_substitute "${value}"
            value="${_mcp_substituted}"
            env_vars+=("${key}=${value}")
        done
    fi

    # Process probe
    local timeout="${ZSH_AI_OPENCODE_MCP_TIMEOUT:-5}"
    [[ "${timeout}" =~ ^[0-9]+$ ]] || timeout=5
    (( timeout > 0 )) || timeout=5

    # Launch in background
    (
        if (( ${#env_vars[@]} > 0 )); then
            local e
            for e in "${env_vars[@]}"; do
                # shellcheck disable=SC2163 # zsh export syntax not supported by shellcheck
                export "${e}"
            done
        fi
        "${final_cmd[@]}" >/dev/null 2>&1 </dev/null
    ) &
    local bg_pid=$!

    # Wait up to timeout seconds
    local waited=0
    while (( waited < timeout )); do
        if ! kill -0 "${bg_pid}" 2>/dev/null; then
            break
        fi
        sleep 1
        (( waited++ ))
    done

    # Check if still running
    if kill -0 "${bg_pid}" 2>/dev/null; then
        # Still running → success (long-running MCP server)
        # First, try SIGTERM
        kill -TERM "${bg_pid}" 2>/dev/null
        
        # Wait for graceful termination (max 2 seconds)
        local term_waited=0
        while (( term_waited < 2 )); do
            if ! kill -0 "${bg_pid}" 2>/dev/null; then
                break
            fi
            sleep 0.1
            (( term_waited++ ))
        done
        
        # If still running, force kill with SIGKILL
        if kill -0 "${bg_pid}" 2>/dev/null; then
            kill -KILL "${bg_pid}" 2>/dev/null
            # Wait for SIGKILL to take effect
            wait "${bg_pid}" 2>/dev/null || true
        fi
        
        message_success "MCP ${name} is healthy"
        return 0
    fi

    # Exited → check exit code
    wait "${bg_pid}" 2>/dev/null
    local exit_code=$?

    if (( exit_code == 0 )); then
        message_success "MCP ${name} is healthy"
        return 0
    else
        message_error "MCP ${name} failed (exit ${exit_code})"
        return 1
    fi
}

# 3.1: Clean runner cache for a server.
function ai::internal::opencode::mcp::_clean_cache {
    local name="${1}"
    if [[ -z "${name}" ]]; then
        message_error "Usage: ai::internal::opencode::mcp::_clean_cache <name>"
        return 1
    fi

    if ! ai::internal::opencode::mcp::_lookup "${name}"; then
        return 1
    fi

    # Remote or empty command → nothing to clean
    if [[ "${_mcp_type}" == "remote" || -z "${_mcp_command}" ]]; then
        message_info "No runner cache to clean for remote MCP ${name}"
        return 0
    fi

    local -a cmd_tokens
    # shellcheck disable=SC2206 # zsh = expansion not supported by shellcheck
    cmd_tokens=(${=_mcp_command})
    local runner="${cmd_tokens[1]}"

    # Helper function to safely remove directories
    # shellcheck disable=SC2034 # used as local function name
    local safe_rm
    safe_rm() {
        # NOTE: avoid variable name 'path' here — in zsh it is linked to $PATH
        local target_path="${1}"
        # Resolve symlinks and normalize path
        local resolved_path="${target_path:A}"

        # Safety checks
        if [[ -z "${HOME}" || "${HOME}" == "/" ]]; then
            message_warning "Invalid HOME environment variable; skipping directory removal"
            return 1
        fi

        # Ensure path is within HOME
        if [[ ! "${resolved_path}" == ${HOME}* ]]; then
            message_warning "Directory ${target_path} is outside HOME; skipping removal"
            return 1
        fi

        # Check if directory exists
        if [[ ! -d "${target_path}" ]]; then
            message_info "Directory ${target_path} does not exist; skipping"
            return 0
        fi

        # Final safety check: ensure we're not removing /
        if [[ "${resolved_path}" == "/" ]]; then
            message_error "Refusing to remove root directory /"
            return 1
        fi

        rm -rf -- "${target_path}" || {
            message_error "Failed to remove ${target_path}"
            return 1
        }
    }

    case "${runner}" in
        uvx)
            message_info "Cleaning uv cache for ${name}..."
            message_warning "Targeted per-package cleanup not viable; cleaning entire ~/.cache/uv"
            if [[ -d "${HOME}/.cache/uv" ]]; then
                safe_rm "${HOME}/.cache/uv" || { message_error "Failed to clean uv cache"; return 1; }
            fi
            ;;
        bunx)
            message_info "Cleaning bun cache for ${name}..."
            message_warning "Targeted per-package cleanup not viable; cleaning entire ~/.bun/install/cache"
            if [[ -d "${HOME}/.bun/install/cache" ]]; then
                safe_rm "${HOME}/.bun/install/cache" || { message_error "Failed to clean bun cache"; return 1; }
            fi
            ;;
        npx)
            message_info "Cleaning npm cache for ${name}..."
            message_warning "Targeted per-package cleanup not viable (~/.npm/_npx/<hash> not mappable by name); cleaning entire ~/.npm/_npx"
            if [[ -d "${HOME}/.npm/_npx" ]]; then
                safe_rm "${HOME}/.npm/_npx" || { message_error "Failed to clean npm cache"; return 1; }
            fi
            ;;
        docker)
            if ! core::exists docker; then
                message_error "docker is not installed"
                return 1
            fi
            # Check if docker daemon is running
            if ! docker info >/dev/null 2>&1; then
                message_error "docker daemon is not running; cannot clean docker cache"
                return 1
            fi
            # Extract image name from command
            local image=""
            local found_run=0
            local token
            for token in "${cmd_tokens[@]}"; do
                if [[ "${token}" == "run" ]]; then
                    found_run=1
                    continue
                fi
                (( found_run )) || continue
                if [[ "${token}" == -* ]]; then
                    continue
                fi
                image="${token}"
                break
            done

            if [[ -z "${image}" ]]; then
                message_warning "Could not determine docker image for ${name}"
                return 1
            fi

            message_info "Cleaning docker image ${image} for ${name}..."
            # Remove stopped containers using this image
            local containers
            containers="$(docker ps -a -q --filter "ancestor=${image}" --filter "status=exited" 2>/dev/null)"
            if [[ -n "${containers}" ]]; then
                echo "${containers}" | xargs -r docker rm -f >/dev/null 2>&1
            fi
            # Remove image
            docker rmi "${image}" >/dev/null 2>&1 || {
                message_warning "Failed to remove docker image ${image}"
                return 1
            }
            # Pull fresh
            message_info "Pulling fresh image ${image}..."
            if ! docker pull "${image}" >/dev/null 2>&1; then
                message_warning "Failed to pull ${image}; will retry on next run"
                return 1
            fi
            ;;
        *)
            # Direct binary or unknown runner
            message_info "No runner cache to clean for direct binary"
            ;;
    esac

    return 0
}

# 3.2/3.3: Reinstall an MCP server (clean cache + re-validate).
function ai::internal::opencode::mcp::reinstall {
    local force=0
    local name=""

    if [[ "${1}" == "--force" ]]; then
        force=1
        name="${2}"
    elif [[ "${2}" == "--force" ]]; then
        force=1
        name="${1}"
    else
        name="${1}"
    fi

    if [[ -z "${name}" ]]; then
        message_error "Usage: ai::internal::opencode::mcp::reinstall <name> [--force]"
        return 1
    fi

    if ! ai::internal::opencode::mcp::_lookup "${name}"; then
        return 1
    fi

    # Remote or empty command → skip
    if [[ "${_mcp_type}" == "remote" || -z "${_mcp_command}" ]]; then
        if [[ "${_mcp_type}" == "remote" ]]; then
            message_info "Skipping remote MCP ${name} (no local command)"
        else
            message_warning "Skipping local MCP ${name}: empty command"
        fi
        return 0
    fi

    # Disabled check
    if [[ "${_mcp_disabled}" == "true" && ${force} -eq 0 ]]; then
        message_warning "${name} is disabled. Use --force to reinstall anyway."
        return 1
    fi

    # Clean cache
    message_info "Cleaning cache for ${name}..."
    if ! ai::internal::opencode::mcp::_clean_cache "${name}"; then
        message_error "Failed to clean cache for ${name}"
        return 1
    fi

    # Re-validate (re-downloads the package)
    message_info "Reinstalling ${name}..."
    if (( force )); then
        if ! ai::internal::opencode::mcp::validate --force "${name}"; then
            message_error "Reinstall failed for ${name}"
            return 1
        fi
    else
        if ! ai::internal::opencode::mcp::validate "${name}"; then
            message_error "Reinstall failed for ${name}"
            return 1
        fi
    fi

    message_success "Reinstalled ${name} successfully"
    return 0
}

# shellcheck shell=bash
# freellmapi internal layer — Docker Compose service lifecycle (no binary on the command line)

# === PATH Loading ===

function ai::internal::freellmapi::load {
    # Deliberate no-op: the official freellmapi installer deploys a Docker
    # Compose stack and ships no executable, no shell hook, and no
    # completion, so there is nothing to prepend to the command line and
    # nothing to create under data/. It is still registered in the
    # "Load paths" block of internal/main.zsh so every ZSH_AI_TOOLS entry
    # has a uniform load step and the intent is documented in code: this
    # is PATH-neutral and returns 0 even when ${ZSH_AI_FREELLMAPI_DIR}
    # does not exist yet (spec: "Load is a PATH-neutral no-op").
    return 0
}

# === Installed Guard ===

function ai::internal::freellmapi::deployed {
    # Artifact guard: the compose file is the deployment's on-disk
    # signature. core::exists is deliberately NOT used — it probes
    # `command -v` for PATH binaries and caches only positives
    # (system/core/internal/api.zsh), and freellmapi installs no binary,
    # so such a guard would never latch and install would re-deploy over
    # a live .env/ENCRYPTION_KEY on every shell load. Endpoint probing is
    # not used either: a stopped-but-installed service must still count
    # as deployed (it belongs to status only).
    [[ -f "${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml" ]]
}

# === Preflight ===

function ai::internal::freellmapi::preflight {
    # Local, self-contained probes mirroring docker/internal/linux.zsh:
    # the ai module loads before docker (alphabetical glob at zshrc), so
    # the docker module's exports do not exist yet, and under the default
    # Linux adapter DOCKER_COMPOSE_TYPE is never exported at all. Only
    # the pass/fail verdict matters before invoking the installer, so the
    # detected flavor (plugin vs standalone) is intentionally NOT
    # exported — status re-probes compose on its own for its ps fallback.
    local msg

    if ! docker info &>/dev/null; then
        msg="freellmapi preflight: Docker daemon is not reachable (docker info failed) — start Docker and retry"
        message_error "${msg}"
        return 1
    fi

    if docker compose version &>/dev/null; then
        # compose plugin available
        :
    elif docker-compose --version &>/dev/null; then
        # standalone docker-compose available
        :
    else
        msg="freellmapi preflight: neither 'docker compose' nor 'docker-compose' is available — install docker-compose-plugin"
        message_error "${msg}"
        return 1
    fi

    if ! command -v curl >/dev/null 2>&1; then
        msg="freellmapi preflight: curl is not installed — required to fetch the official installer"
        message_error "${msg}"
        return 1
    fi

    return 0
}

# === Display Read-back ===

function ai::internal::freellmapi::read_env {
    # Usage: ai::internal::freellmapi::read_env <KEY> <default>
    # Reads <KEY> from ${ZSH_AI_FREELLMAPI_DIR}/.env (ignoring comments,
    # surrounding whitespace, and one layer of quotes) and stores the
    # result in the shell-global ${ZSH_AI_FREELLMAPI_ENV_VALUE}, falling
    # back to <default> when the file or the key is absent. Read-only:
    # the module NEVER writes .env — the official installer is the single
    # writer (a second writer could clobber ENCRYPTION_KEY, and losing it
    # makes every stored provider key unrecoverable).
    local key="${1}"
    local fallback="${2}"
    local value=""
    local line

    if [[ -f "${ZSH_AI_FREELLMAPI_DIR}/.env" ]]; then
        while IFS= read -r line; do
            # strip leading whitespace, skip blanks and comments
            line="${line#"${line%%[![:space:]]*}"}"
            [[ -z "${line}" || "${line}" == \#* ]] && continue
            [[ "${line}" == "${key}="* ]] || continue
            value="${line#*=}"
            # strip surrounding whitespace, then one layer of quotes
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"
            case "${value}" in
                \"*\") value="${value#\"}"; value="${value%\"}" ;;
                \'*\') value="${value#\'}"; value="${value%\'}" ;;
            esac
            break
        done < "${ZSH_AI_FREELLMAPI_DIR}/.env"
    fi

    if [[ -z "${value}" ]]; then
        value="${fallback}"
    fi
    typeset -g ZSH_AI_FREELLMAPI_ENV_VALUE="${value}"
}

# === Post-install Guidance ===

function ai::internal::freellmapi::post_install {
    # Display-time read-back: a user may have edited PORT/HOST_BIND in
    # .env, so prefer those over the config defaults (the config values
    # only mirror the upstream defaults for the pre-deployment case).
    ai::internal::freellmapi::read_env "PORT" "${ZSH_AI_FREELLMAPI_PORT:-3001}"
    local port="${ZSH_AI_FREELLMAPI_ENV_VALUE}"
    ai::internal::freellmapi::read_env "HOST_BIND" "${ZSH_AI_FREELLMAPI_HOST_BIND:-127.0.0.1}"
    local host="${ZSH_AI_FREELLMAPI_ENV_VALUE}"

    local dashboard="http://${host}:${port}"
    local env_file="${ZSH_AI_FREELLMAPI_DIR}/.env"
    local msg

    msg="freellmapi dashboard: ${dashboard}"
    message_info "${msg}"

    msg="next step: open the dashboard and add your provider keys in the Keys section"
    message_info "${msg}"

    msg="point clients at ${dashboard}/v1 (OpenAI-compatible) and ${dashboard}/v1/messages (Anthropic)"
    message_info "${msg}"

    msg="keep ${env_file} safe: losing its ENCRYPTION_KEY makes every stored provider key unrecoverable — they must be re-entered"
    message_warning "${msg}"

    return 0
}

# === Tool Install ===

function ai::internal::freellmapi::install {
    local msg
    local err
    local waited
    local healthy=0

    if ai::internal::freellmapi::deployed; then
        msg="freellmapi is already deployed at ${ZSH_AI_FREELLMAPI_DIR} — skipping install (.env untouched)"
        message_info "${msg}"
        return 0
    fi

    ai::internal::freellmapi::preflight || return 1

    msg="Installing freellmapi from ${ZSH_AI_FREELLMAPI_INSTALL_URL}"
    message_info "${msg}"

    # FREELLMAPI_DIR is a per-invocation env prefix on the installer call
    # only — never exported globally — so the directory the installer
    # writes is exactly the one the guard and status inspect, without
    # leaking into the user's shell.
    setopt localoptions pipefail
    if ! curl -fsSL "${ZSH_AI_FREELLMAPI_INSTALL_URL}" | FREELLMAPI_DIR="${ZSH_AI_FREELLMAPI_DIR}" bash; then
        err="freellmapi installer failed (non-zero exit) — re-run ai::freellmapi::install to retry"
        message_error "${err}"
        return 1
    fi

    # Health poll: up to 60s total, one 2s-timeout attempt every 2s.
    waited=0
    while (( waited < 60 )); do
        if curl -fsS --max-time 2 "${ZSH_AI_FREELLMAPI_HEALTH_URL}" &>/dev/null; then
            healthy=1
            break
        fi
        sleep 2
        (( waited += 2 ))
    done

    if (( ! healthy )); then
        # Warning, not an error: the service may just still be starting.
        msg="freellmapi deployed, but ${ZSH_AI_FREELLMAPI_HEALTH_URL} did not answer within 60s — it may still be starting; verify with ai::freellmapi::status"
        message_warning "${msg}"
    fi

    msg="freellmapi installed successfully (compose project: ${ZSH_AI_FREELLMAPI_DIR})"
    message_success "${msg}"

    ai::internal::freellmapi::post_install
    return 0
}

# === Tool Upgrade ===

function ai::internal::freellmapi::upgrade {
    local msg
    local err

    ai::internal::freellmapi::preflight || return 1

    msg="Upgrading freellmapi from ${ZSH_AI_FREELLMAPI_INSTALL_URL} (.env and ENCRYPTION_KEY preserved)"
    message_info "${msg}"

    # Same official installer as install — re-running it IS the upstream
    # update path, and its idempotency preserves .env/ENCRYPTION_KEY.
    # FREELLMAPI_DIR again as a per-invocation env prefix only.
    setopt localoptions pipefail
    if ! curl -fsSL "${ZSH_AI_FREELLMAPI_INSTALL_URL}" | FREELLMAPI_DIR="${ZSH_AI_FREELLMAPI_DIR}" bash; then
        err="freellmapi upgrade failed (non-zero exit) — re-run ai::freellmapi::upgrade to retry"
        message_error "${err}"
        return 1
    fi

    msg="freellmapi upgraded successfully (compose project: ${ZSH_AI_FREELLMAPI_DIR})"
    message_success "${msg}"
    return 0
}

# === Status ===

function ai::internal::freellmapi::status {
    local msg

    # Gate 1 — artifacts: without the compose file nothing is deployed.
    if ! ai::internal::freellmapi::deployed; then
        msg="freellmapi is not deployed (no ${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml) — run ai::freellmapi::install"
        message_error "${msg}"
        return 1
    fi

    # Display-time read-back of user-editable values from .env.
    ai::internal::freellmapi::read_env "PORT" "${ZSH_AI_FREELLMAPI_PORT:-3001}"
    local port="${ZSH_AI_FREELLMAPI_ENV_VALUE}"
    ai::internal::freellmapi::read_env "HOST_BIND" "${ZSH_AI_FREELLMAPI_HOST_BIND:-127.0.0.1}"
    local host="${ZSH_AI_FREELLMAPI_ENV_VALUE}"

    # Gate 2 — runtime: the health endpoint is the primary signal (the
    # same GET the upstream healthcheck uses); `compose ps -q` non-empty
    # is only the fallback for the pathological case where curl is absent.
    if command -v curl >/dev/null 2>&1; then
        if curl -fsS --max-time 2 "${ZSH_AI_FREELLMAPI_HEALTH_URL}" &>/dev/null; then
            msg="freellmapi is running and healthy — dashboard http://${host}:${port} (health probe: ${ZSH_AI_FREELLMAPI_HEALTH_URL})"
            message_success "${msg}"
            return 0
        fi
        msg="freellmapi is deployed at ${ZSH_AI_FREELLMAPI_DIR} but not responding at ${ZSH_AI_FREELLMAPI_HEALTH_URL} — inspect with: docker compose -f ${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml ps  and  docker compose -f ${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml logs -f"
        message_warning "${msg}"
        return 1
    fi

    local ids=""
    if docker compose version &>/dev/null; then
        ids="$(docker compose -f "${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml" ps -q 2>/dev/null)"
    elif docker-compose --version &>/dev/null; then
        ids="$(docker-compose -f "${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml" ps -q 2>/dev/null)"
    fi

    if [[ -n "${ids}" ]]; then
        msg="freellmapi is deployed at ${ZSH_AI_FREELLMAPI_DIR} with running containers — dashboard http://${host}:${port} (curl missing: health endpoint not verified)"
        message_success "${msg}"
        return 0
    fi

    msg="freellmapi is deployed at ${ZSH_AI_FREELLMAPI_DIR} but not responding — inspect with: docker compose -f ${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml ps  and  docker compose -f ${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml logs -f"
    message_warning "${msg}"
    return 1
}

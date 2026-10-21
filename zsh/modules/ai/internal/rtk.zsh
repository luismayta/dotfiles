# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::rtk::load {
    [ -e "${ZSH_AI_RTK_BIN_PATH}/rtk" ] && export PATH="${ZSH_AI_RTK_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::rtk::install::run {
    # Shared installer body used by both `install` and `upgrade`.
    #
    # `upgrade` calls this helper instead of `install` so the
    # already-installed guard is skipped and the upstream installer always
    # runs. Every failure branch returns 1 explicitly — message_error
    # itself returns 0.
    local msg

    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    # pipefail so a failed download is not masked by the exit status of `sh`.
    setopt localoptions pipefail
    if ! curl -fsSL "${ZSH_AI_RTK_INSTALL_URL}" | sh; then
        message_error "Failed to install rtk"
        return 1
    fi

    # The installer exiting zero does not mean `rtk` is reachable: the
    # binary lands in ${ZSH_AI_RTK_BIN_PATH}, which is not guaranteed to be
    # on PATH. An unreachable binary is an incomplete install — say where it
    # landed and return non-zero instead of claiming success.
    if ! core::exists rtk; then
        msg="rtk was installed but does not resolve on PATH — expected it at ${ZSH_AI_RTK_BIN_PATH}; add that directory to your PATH and re-run"
        message_warning "${msg}"
        return 1
    fi

    return 0
}

function ai::internal::rtk::install {
    if core::exists rtk; then
        message_info "rtk is already installed — skipping"
        return 0
    fi

    message_info "Installing rtk..."
    ai::internal::rtk::install::run || return 1

    message_success "rtk installed successfully"
    return 0
}

function ai::internal::rtk::upgrade {
    # Upgrade deliberately bypasses the already-installed guard of
    # `ai::internal::rtk::install` so the upstream installer always runs.
    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    message_info "Upgrading rtk..."
    ai::internal::rtk::install::run || return 1

    message_success "Upgraded rtk"
    return 0
}

# === Setup ===

function ai::internal::rtk::setup {
    # Configures rtk for the opencode agent by delegating to the upstream
    # `rtk init -g --opencode`. That command is non-interactive upstream,
    # so no TTY branching is needed here. Extra flags given by the user are
    # passed through to `rtk init` untouched.
    local msg
    local rc

    if ! core::exists rtk; then
        msg="rtk is not installed — run ai::rtk::install first"
        message_error "${msg}"
        return 1
    fi

    rtk init -g --opencode "${@}"
    rc=$?

    if (( rc != 0 )); then
        msg="rtk setup failed (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    message_success "rtk configured for opencode"
    return 0
}

# === Config Sync ===

function ai::internal::rtk::config::sync {
    local src="${ZSH_AI_RTK_CONFIG_SOURCE_PATH}"
    local dst="${ZSH_AI_RTK_CONFIG_PATH}"
    local msg
    local rc

    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    if [[ ! -d "$src" ]]; then
        message_error "no rtk config source at ${src}"
        return 1
    fi

    if ! mkdir -p "$dst"; then
        msg="failed to create rtk config directory ${dst}"
        message_error "${msg}"
        return 1
    fi

    rsync -a "${src}/" "${dst}/"
    rc=$?

    if (( rc != 0 )); then
        msg="rsync failed to sync rtk config (exit ${rc})"
        message_error "${msg}"
        return 1
    fi

    message_success "rtk config synced"
    return 0
}

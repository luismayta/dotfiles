# shellcheck shell=bash

# ──────────────────────────────────────────────
# Shell wrapper — directory-preserving yazi launcher
# ──────────────────────────────────────────────

# y() — launch yazi with --cwd-file support.
# On exit, changes shell directory to the last-browsed path.
# Arguments are forwarded to yazi (e.g., y /some/path).
function y {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"

    command yazi "${@}" --cwd-file="$tmp"

    if [[ -f "$tmp" ]]; then
        local cwd
        cwd="$(<"$tmp")"
        if [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
            builtin cd "$cwd" || true
        fi
        rm -f "$tmp"
    fi
}

# ──────────────────────────────────────────────
# Config editor — open yazi config in $EDITOR
# ──────────────────────────────────────────────

# edityazi — open yazi config dir (default) or a specific file.
function edityazi {
    if [[ -z "${1}" ]]; then
        "${EDITOR}" "${ZSH_YAZI_CONFIG_DIR}"
        return
    fi
    "${EDITOR}" "${ZSH_YAZI_CONFIG_DIR}/${1}"
}

# ──────────────────────────────────────────────
# Setup orchestrator
# ──────────────────────────────────────────────

# yazi::setup — ensure yazi is installed and config is synced.
function yazi::setup {
    if core::exists yazi; then
        message_info "${ZSH_YAZI_PACKAGE_NAME} is already installed"
    else
        yazi::install
    fi

    yazi::sync
}

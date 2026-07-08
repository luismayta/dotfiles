# shellcheck shell=bash

# ──────────────────────────────────────────────
# Shell wrapper — directory-preserving yazi launcher
# ──────────────────────────────────────────────

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
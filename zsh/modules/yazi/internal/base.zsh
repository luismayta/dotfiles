# shellcheck shell=bash

# ──────────────────────────────────────────────
# Install helpers
# ──────────────────────────────────────────────

function yazi::internal::install {
    core::ensure yazi
}

function yazi::internal::theme::download {
    mkdir -p "${ZSH_YAZI_DATA_PATH}"
    if ! curl -fsSL "${ZSH_YAZI_THEME_URL}" -o "${ZSH_YAZI_DATA_PATH}/theme.toml"; then
        message_warning "Could not download yazi theme from ${ZSH_YAZI_THEME_URL}; keeping existing vendored theme.toml"
        return 0
    fi
}

function yazi::internal::config::sync {
    yazi::internal::theme::download
    rsync -avzh --delete \
        --exclude=plugins/ \
        --exclude=flavors/ \
        "${ZSH_YAZI_DATA_PATH}/" "${ZSH_YAZI_CONFIG_PATH}/"
}


# shellcheck shell=bash

# ──────────────────────────────────────────────
# Install helpers
# ──────────────────────────────────────────────

function yazi::internal::install {
    core::ensure yazi
}

function yazi::internal::theme::download {
    local url="https://raw.githubusercontent.com/BriBian08/tokyonight-yazi/main/themes/tokyonight-storm.toml"
    mkdir -p "${ZSH_YAZI_DATA_PATH}"
    curl -fsSL "$url" -o "${ZSH_YAZI_DATA_PATH}/theme.toml"
}

function yazi::internal::config::sync {
    yazi::internal::theme::download
    rsync -avzh --delete \
        --exclude=plugins/ \
        --exclude=flavors/ \
        "${ZSH_YAZI_DATA_PATH}/" "${ZSH_YAZI_CONFIG_PATH}/"
}



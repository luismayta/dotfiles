# shellcheck shell=bash

function ai::hunk::install {
    ai::internal::hunk::install
}

function ai::hunk::review {
    hunk diff "${@}"
}

function ai::hunk::show {
    hunk show "${@}"
}

function ai::hunk::daemon::start {
    hunk daemon serve &
    message_info "hunk daemon started (PID $!)"
}

function ai::hunk::config::sync {
    local src="${AI_PATH}/data/hunk/config.toml"
    local dst="${AI_HUNK_CONFIG_PATH}/config.toml"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        message_success "hunk config synced"
    else
        message_warning "no hunk config template at ${src}"
    fi
}

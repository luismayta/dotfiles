#!/usr/bin/env ksh

function ai::tuicr::install {
    ai::internal::tuicr::install
}

function ai::tuicr::review {
    tuicr "${@}"
}

function ai::tuicr::pr {
    tuicr pr "${@}"
}

function ai::tuicr::sync {
    local src="${ZSH_AI_PATH}/data/tuicr/config.toml"
    local dst="${ZSH_AI_TUICR_CONFIG_PATH}/config.toml"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        message_success "tuicr config synced"
    else
        message_warning "no tuicr config template at ${src}"
    fi
}

function ai::tuicr::post_install {
    message_success "tuicr installed — run ai::tuicr::review to start a code review"
    message_info "run ai::tuicr::sync to set up config"
}

# shellcheck shell=bash

# editopencode edit settings for opencode
function editopencode {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${AI_OPENCODE_CONFIG_FILE_PATH}"
}

function ai::opencode::install {
    ai::internal::opencode::install
}

function ai::opencode::sync {
    ai::internal::opencode::sync
}

function ai::fabric::install {
    ai::internal::fabric::install
}

function ai::fabric::patterns::sync {
    ai::internal::fabric::patterns::sync
}

function ai::fabric::patterns::pull {
    ai::internal::fabric::patterns::pull
}

function ai::ollama::install {
    ai::internal::ollama::install
}

function ai::ollama::models::list {
    ai::internal::ollama::models::list
}

function ai::ollama::models::pull {
    ai::internal::ollama::models::pull "${@}"
}

function ai::ollama::models::install {
    ai::internal::ollama::models::install
}

function ai::shimmy::install {
    ai::internal::shimmy::install
}

function ai::hf::install {
    ai::internal::hf::install
}

function ai::openclaw::install {
    ai::internal::openclaw::install
}

function ai::codegraph::install {
    ai::internal::codegraph::install
}

function ai::tmuxai::install {
    ai::internal::tmuxai::install
}

function ai::rtk::install {
    ai::internal::rtk::install
}

function ai::hunk::install {
    ai::internal::hunk::install
}

function ai::pi::install {
    ai::internal::pi::install
}

function ai::pi::config::sync {
    ai::internal::pi::config::sync
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

function ai::graphify::install {
    ai::internal::graphify::install
}

function ai::graphify::upgrade {
    ai::internal::graphify::upgrade
}

function ai::sync {
    ai::opencode::sync
    ai::fabric::patterns::sync
    ai::hunk::config::sync
    ai::pi::config::sync
}

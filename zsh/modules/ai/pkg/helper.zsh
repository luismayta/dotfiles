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

# shellcheck shell=bash

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

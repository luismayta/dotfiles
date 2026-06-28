# shellcheck shell=bash

function git::setup {
    git::pkg::config::setup
    git::dependences::check
    message_success "Git setup complete."
}

# shellcheck shell=bash

function issues::setup {
    issues::pkg::config::setup
    issues::dependences
    message_success "Issues setup complete."
}

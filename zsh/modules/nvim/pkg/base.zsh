# shellcheck shell=bash
#
# Public API for the nvim module.
# Thin wrappers around internal functions.

function nvim::sync {
    nvim::internal::sync "$@"
}

function nvim::install {
    nvim::internal::install "$@"
}

function nvim::upgrade {
    nvim::internal::upgrade "$@"
}

function nvim::clean {
    nvim::internal::clean "$@"
}

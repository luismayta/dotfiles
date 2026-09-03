# shellcheck shell=bash
#
# Public API for the helix module.
# Thin wrappers around internal functions.

function helix::install {
    helix::internal::install "$@"
}

function helix::sync {
    helix::internal::sync "$@"
}

function helix::post_install {
    helix::internal::post_install "$@"
}

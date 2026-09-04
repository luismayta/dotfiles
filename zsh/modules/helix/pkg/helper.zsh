# shellcheck shell=bash
#
# Helper functions for helix.

# Full helix setup: install binary, sync config, build grammars
function helix::setup {
    helix::install
    helix::sync
    helix::post_install
}

# Upgrade helix: update binary and grammars
function helix::upgrade_all {
    helix::upgrade
    helix::sync
}

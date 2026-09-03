# shellcheck shell=bash
#
# Helper functions for helix.

# Full helix setup: install binary, sync config, build grammars
function helix::setup {
    helix::install
    helix::sync
    helix::post_install
}

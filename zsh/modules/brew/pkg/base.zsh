# shellcheck shell=bash

# Auto-install if brew not found
if ! type -p brew > /dev/null; then
    brew::install
    brew::post_install
fi

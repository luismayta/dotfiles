# shellcheck shell=bash

# Fix for autosuggest when copy-pasting, it prints super slow on long buffers (pastes)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=15
export ZSH_AUTOSUGGEST_USE_ASYNC=true

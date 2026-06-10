# shellcheck shell=bash
# Bind templates::run to Ctrl-X t
zle -N templates::run
bindkey '^Xt' templates::run

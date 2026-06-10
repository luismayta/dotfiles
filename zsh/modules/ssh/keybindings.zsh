# shellcheck shell=bash
# Bind ssh::connect to Ctrl-X s
zle -N ssh::connect
bindkey '^Xs' ssh::connect

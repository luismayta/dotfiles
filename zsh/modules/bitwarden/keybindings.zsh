# shellcheck shell=bash
# Bind fbw (bitwarden search) to Ctrl-X k
zle -N fbw
bindkey '^Xk' fbw

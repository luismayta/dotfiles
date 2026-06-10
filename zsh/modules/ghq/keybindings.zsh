# shellcheck shell=bash
# Bind ghq::find::project to Ctrl-X p
zle -N ghq::find::project
bindkey '^Xp' ghq::find::project

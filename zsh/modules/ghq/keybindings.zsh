# shellcheck shell=bash
# Optional extension (outside the 3-layer scaffold): binds ghq::find::project to Ctrl-X p.
# Kept as a module-level extension per docs/guides/create-module.md guidance.
zle -N ghq::find::project
bindkey '^Xp' ghq::find::project

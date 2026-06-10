# shellcheck shell=bash

function rust::internal::delta::load {
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global merge.conflictStyle zdiff3
}

function rust::internal::zoxide::load {
  eval "$(zoxide init zsh)"
}

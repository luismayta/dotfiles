# shellcheck shell=bash

function rust::internal::zoxide::load {
  eval "$(zoxide init zsh)"
}

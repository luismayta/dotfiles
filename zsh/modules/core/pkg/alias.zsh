#
# eza (modern ls) aliases and auto-install
#

eza::load() {
  alias ls='eza --icons=auto'
  alias ll='eza --long --header --git --group --icons=auto'
  alias lsa='eza --long --header --git --group --all --icons=auto'
}

if ! core::exists eza; then core::cargo::install eza; fi
if core::exists eza; then eza::load; fi

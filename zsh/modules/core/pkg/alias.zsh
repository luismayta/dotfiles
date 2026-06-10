#
# shellcheck shell=bash
# eza (modern ls) aliases and auto-install
#

eza::load() {
  alias ls='eza --icons=auto'
  alias ll='eza --long --header --git --group --icons=auto'
  alias lsa='eza --long --header --git --group --all --icons=auto'
}

if ! core::exists eza; then core::cargo::install eza; fi
if core::exists eza; then eza::load; fi

# System aliases
alias df='df -h'
alias free='free -m'
alias gurl='curl --compressed'
alias week='date +%V'
alias whois="whois -h whois-servers.net"
alias wget='wget --user-agent="Mozilla/4.0 (Windows; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"'

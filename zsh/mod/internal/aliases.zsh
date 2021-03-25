#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# System

alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# Gzip-enabled `curl`
alias gurl='curl --compressed'

# Get week number
alias week='date +%V'

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# download
alias wget='wget --user-agent="Mozilla/4.0 (Windows; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"'

# alias git
alias gc='git commit --verbose'

# Make nvim the default editor
if type -p nvim > /dev/null; then
    alias oldvim='vim'
    alias vim='nvim'
    alias vi='nvim'
    alias vimdiff='nvim -d'
fi


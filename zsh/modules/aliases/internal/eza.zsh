#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function eza::install {
    if ! type brew > /dev/null; then
        message_warning "${CORE_MESSAGE_BREW}"
        return
    fi
    message_info "Installing eza"
    core::install eza
    message_success "Installed eza"
}

if ! type eza > /dev/null; then
    eza::install
fi

function eza::init {
    alias l='eza --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
    alias ls='eza --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
    alias ll='eza -l --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
    alias lll='eza -l --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all | less'
    alias lla='eza -la --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
    alias llt='eza -T --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
    alias llfu='eza -bghHliS --all --grid --git --sort=ext --color=always --group-directories-first --icons=auto --color-scale=all'
}

if type eza > /dev/null; then
    eza::init
fi

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function eza::install {
    if ! type brew > /dev/null; then
        message_warning "please install brew or use luismayta/zsh-brew"
        return
    fi
    message_info "Installing eza"
    brew install eza
    message_success "Installed eza"
}

if ! type eza > /dev/null; then
    eza::install
fi

function eza::init {
    alias l='eza --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
    alias ls='eza --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
    alias ll='eza -l --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
    alias lll='eza -l --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale | less'
    alias lla='eza -la --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
    alias llt='eza -T --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
    alias llfu='eza -bghHliS --all --grid --git --sort=ext --color=always --group-directories-first --icons --color-scale'
}

if type eza > /dev/null; then
    eza::init
fi

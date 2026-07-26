#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# GitHub CLI aliases

alias ghd="gh dash"

function editghdash {
    if [ -z "${EDITOR}" ]; then
        message_warning "EDITOR is not set. Please set EDITOR to edit gh-dash config."
        return 1
    fi
    "${EDITOR}" "${ZSH_GITHUB_DASH_CONF_FILE}"
}
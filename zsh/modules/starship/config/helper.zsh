#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function starship::config::load {
    if [ ! -e "${STARSHIP_CACHE}" ]; then
        mkdir -p "${STARSHIP_CACHE}"
    fi
}

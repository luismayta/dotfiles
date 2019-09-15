#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "provision/script/bootstrap.sh" ] && source "provision/script/bootstrap.sh"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi
replace_files

#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "extras/script/bootstrap.sh" ] && source "extras/script/bootstrap.sh"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi
replace_files

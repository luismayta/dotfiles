#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi
replace_files

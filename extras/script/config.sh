#!/usr/bin/env bash
# -*- coding: utf-8 -*-

if [[ $(uname) == 'Darwin' ]]; then
    # shellcheck source=/dev/null
	[ -r "${FILE_SETTINGS_OSX}" ] && source "${FILE_SETTINGS_OSX}"
else
    # shellcheck source=/dev/null
	[ -r "${FILE_SETTINGS_LINUX}" ] && source "${FILE_SETTINGS_LINUX}"
fi

#!/usr/bin/env bash
# -*- coding: utf-8 -*-

if [[ $(uname) == 'Darwin' ]]; then
    # shellcheck source=script/settings/osx.sh
	[ -r "$FILE_SETTINGS_OSX" ] && source "$FILE_SETTINGS_OSX"
else
    # shellcheck source=script/settings/linux.sh
	[ -r "$FILE_SETTINGS_LINUX" ] && source "$FILE_SETTINGS_LINUX"
fi

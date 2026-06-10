#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# editstarship edit settings for starship
function editstarship {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${STARSHIP_FILE_SETTINGS}"
}

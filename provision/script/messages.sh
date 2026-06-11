#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function msg() {
    printf '%b\n' "$1" >&2
}

function success() {
    # shellcheck disable=SC2154
    if [[ "${ret:-0}" -eq '0' ]]; then
        msg "\e[32m[✔]\e[0m ${1}${2:-}"
    fi
}

function error() {
    msg "\e[31m[✘]\e[0m ${1}${2:-}"
    exit 1
}

function debug() {
    if [ "${DEBUG_MODE:-0}" -eq '1' ] && [ "${ret:-0}" -gt '1' ]; then
      msg "An error occurred in function \"${FUNCNAME[1]:-unknown}\" on line ${BASH_LINENO[1]:-0}, we're sorry for that."
    fi
}
#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function msg() {
    printf '%b\n' "$1" >&2
}

function success() {
    if [[ "${ret}" -eq '0' ]]; then
        msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

function error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

function debug() {
    if [ "$DEBUG_MODE" -eq '1' ] && [ "$ret" -gt '1' ]; then
      msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

# shellcheck shell=bash
# Notify notify-send public API

function notify::notify-send::install {
    notify::notify-send::internal::install
}

function notify::notify-send::send {
    notify::notify-send::internal::send "${1}" "${2}" "${3}"
}

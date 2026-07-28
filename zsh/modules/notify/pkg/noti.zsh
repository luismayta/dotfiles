# shellcheck shell=bash
# Notify noti public API

function notify::noti::install {
    notify::noti::internal::install
}

function notify::noti::render {
    notify::noti::internal::render
}

function notify::noti::sync {
    notify::noti::internal::sync
}

function notify::noti::send {
    notify::noti::internal::send "${1}" "${2}" "${3}"
}

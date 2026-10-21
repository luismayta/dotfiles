# shellcheck shell=bash
# rea public wrappers

function ai::rea::install {
    ai::internal::rea::install "${@}"
}

function ai::rea::doctor {
    ai::internal::rea::doctor "${@}"
}

function ai::rea::setup {
    ai::internal::rea::setup "${@}"
}

function ai::rea::update {
    ai::internal::rea::update "${@}"
}

function ai::rea::uninstall {
    ai::internal::rea::uninstall "${@}"
}

function ai::rea::post_install {
    ai::internal::rea::post_install "${@}"
}

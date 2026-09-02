# shellcheck shell=bash

function ai::archify::install {
    ai::internal::archify::install
}

function ai::archify::doctor {
    archify doctor "${@}"
}

function ai::archify::render {
    archify render "${@}"
}

function ai::archify::validate {
    archify validate "${@}"
}

function ai::archify::deliver {
    archify deliver "${@}"
}

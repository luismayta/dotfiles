# shellcheck shell=bash

function ai::skills::install {
    ai::internal::skills::install
}

function ai::skills::add {
    ai::internal::skills::add "${@}"
}

function ai::skills::use {
    ai::internal::skills::use "${@}"
}

function ai::skills::list {
    ai::internal::skills::list
}

function ai::skills::update {
    ai::internal::skills::update
}

function ai::skills::setup {
    ai::internal::skills::setup
}

function ai::skills::search {
    ai::internal::skills::search "${@}"
}

function ai::skills::publish {
    ai::internal::skills::publish "${@}"
}

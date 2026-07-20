# shellcheck shell=bash

function ai::shimmy::install {
    ai::internal::shimmy::install
}

function ai::hf::install {
    ai::internal::hf::install
}

function ai::openclaw::install {
    ai::internal::openclaw::install
}

function ai::codegraph::install {
    ai::internal::codegraph::install
}

function ai::codegraph::init {
    ai::internal::codegraph::init
}

function ai::codegraph::setup {
    ai::internal::codegraph::setup
}

function ai::codegraph::update {
    ai::internal::codegraph::update
}

function ai::codegraph::upgrade {
    ai::internal::codegraph::upgrade
}

function ai::tmuxai::install {
    ai::internal::tmuxai::install
}

function ai::rtk::install {
    ai::internal::rtk::install
}

function ai::pi::install {
    ai::internal::pi::install
}

function ai::pi::config::sync {
    ai::internal::pi::config::sync
}

function ai::sync {
    ai::opencode::sync
    ai::fabric::patterns::sync
    ai::hunk::config::sync
    ai::pi::config::sync
}

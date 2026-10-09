#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::duckdb::install {
    devops::duckdb::internal::main::factory
}

function devops::duckdb::upgrade {
    devops::duckdb::internal::upgrade
}

function devops::duckdb::is_installed {
    core::exists duckdb
}

function devops::duckdb::post_install {
    message_info "Post Install ${DEVOPS_DUCKDB_PACKAGE_NAME}"
    message_success "DuckDB installed! Run 'duckdb' to start the REPL, or 'duckdb <file>.duckdb' to open/create a database file."
}

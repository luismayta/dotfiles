#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::duckdb::internal::load {
    core::path::prepend "${DEVOPS_DUCKDB_ROOT_BIN}"
}

function devops::duckdb::internal::install {
    message_info "Installing ${DEVOPS_DUCKDB_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_DUCKDB_INSTALL_URL}" | bash
    message_success "Installed ${DEVOPS_DUCKDB_PACKAGE_NAME}"
}

function devops::duckdb::internal::upgrade {
    message_info "Upgrading ${DEVOPS_DUCKDB_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_DUCKDB_INSTALL_URL}" | bash
    message_success "Upgraded ${DEVOPS_DUCKDB_PACKAGE_NAME}"
}

function devops::duckdb::internal::main::factory {
    if ! core::exists duckdb; then
        devops::duckdb::internal::install
    fi
}

devops::duckdb::internal::load

devops::duckdb::internal::main::factory

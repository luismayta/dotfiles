# shellcheck shell=bash

if ! core::exists reattach-to-user-namespace; then core::install reattach-to-user-namespace; fi

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::k9s::internal::main::factory {
    core::ensure k9s
}

devops::k9s::internal::main::factory

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::helm::internal::main::factory {
    core::ensure helm
}

devops::helm::internal::main::factory

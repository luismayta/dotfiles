#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::helm::install {
    devops::helm::internal::main::factory
}

function devops::helm::upgrade {
    core::upgrade helm
}

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::bruno::load {
    devops::bruno::internal::load
}

function devops::bruno::bru::install {
  devops::bruno::internal::bru::install
}

function devops::bruno::sync {
  devops::bruno::internal::sync
}
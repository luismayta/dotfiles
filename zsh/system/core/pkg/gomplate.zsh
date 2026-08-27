#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Gomplate public API

core::gomplate::exists() {
  core::internal::gomplate::exists
}

core::gomplate::load() {
  core::internal::gomplate::load
}

core::gomplate::install() {
  core::internal::gomplate::install
}

core::gomplate::ensure() {
  core::gomplate::exists || core::gomplate::install
}

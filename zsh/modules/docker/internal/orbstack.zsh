#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function container::internal::container::install {
  if core::exists docker; then return; fi
  message_info "Installing ${DOCKER_PACKAGE_NAME}"
  core::install orbstack
  message_success "Installed ${DOCKER_PACKAGE_NAME}"
}

function container::internal::container::load {
  return
}

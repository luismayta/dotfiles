#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::install {
  devops::internal::packages::install
  devops::internal::go::packages::install
}

function devops::post_install {
  message_info "Post Install ${DEVOPS_PACKAGE_NAME}"
  message_success "Success Install ${DEVOPS_PACKAGE_NAME}"
}

function devops::upgrade {
  core::upgrade
}

function devops::packages::install {
  devops::internal::packages::install
}

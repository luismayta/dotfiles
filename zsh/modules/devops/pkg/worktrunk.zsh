#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::worktrunk::install {
    devops::worktrunk::internal::wt::install
}

function devops::worktrunk::upgrade {
    devops::worktrunk::internal::upgrade
}

function devops::worktrunk::post_install {
    message_info "Worktrunk post-install setup"
    echo ""
    echo "Run the following command to set up shell integration:"
    echo "  wt config shell install"
    echo ""
    message_success "Worktrunk post-install complete"
}

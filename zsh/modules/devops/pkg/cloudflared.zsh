#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::cloudflared::install {
    devops::cloudflared::internal::install
}

function devops::cloudflared::upgrade {
    devops::cloudflared::internal::upgrade
}

function devops::cloudflared::is_installed {
    core::exists cloudflared
}

function devops::cloudflared::tunnel::create {
    devops::cloudflared::internal::tunnel::create "${@}"
}

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::sync {
    devops::k9s::sync
    devops::komiser::sync
}

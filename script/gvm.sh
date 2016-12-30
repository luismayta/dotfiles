#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

# shellcheck source=/dev/null
[ -r "$HOME/.gvm/scripts/gvm" ] && source "$HOME/.gvm/scripts/gvm"

gvm pkgset list | grep -q "${GVM_NAME}"
response=$?

if [[ ! "${response}" -eq '0' ]]; then
    gvm pkgset create "${GVM_NAME}"
fi

gvm pkgset use "${GVM_NAME}"

mkdir -p "${GOPATH}/src"
mkdir -p "${GOPATH}/pkg"
mkdir -p "${GOPATH}/bin"

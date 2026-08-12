#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::cloudflared::internal::load {
    core::path::prepend "${DEVOPS_CLOUDFLARED_ROOT_BIN}"

    if ! core::exists cloudflared; then
        return
    fi

    # cloudflared is available on PATH
}

function devops::cloudflared::internal::install {
    if core::exists cloudflared; then
        log::debug "cloudflared already installed"
        return 0
    fi

    message_info "Installing ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"

    local tmp_bin="/tmp/cloudflared"

    curl -fsSL "${DEVOPS_CLOUDFLARED_DOWNLOAD_URL}" -o "${tmp_bin}"

    if [[ -n "${DEVOPS_CLOUDFLARED_SHA256}" ]]; then
        echo "${DEVOPS_CLOUDFLARED_SHA256}  ${tmp_bin}" | sha256sum -c -
    fi

    chmod +x "${tmp_bin}"
    mkdir -p "${DEVOPS_CLOUDFLARED_ROOT_BIN}"
    mv "${tmp_bin}" "${DEVOPS_CLOUDFLARED_BIN}"

    message_success "Installed ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"
}

function devops::cloudflared::internal::upgrade {
    if ! core::exists cloudflared; then
        devops::cloudflared::internal::install
        return
    fi

    message_info "Upgrading ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"
    cloudflared update
    message_success "Upgraded ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"
}

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
        message_info "cloudflared already installed"
        return 0
    fi

    message_info "Installing ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"

    local tmp_bin="/tmp/cloudflared"

    if ! curl -fsSL "${DEVOPS_CLOUDFLARED_DOWNLOAD_URL}" -o "${tmp_bin}"; then
        message_error "Failed to download ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"
        return 1
    fi

    if [[ -n "${DEVOPS_CLOUDFLARED_SHA256}" ]]; then
        if ! echo "${DEVOPS_CLOUDFLARED_SHA256}  ${tmp_bin}" | sha256sum -c -; then
            message_error "SHA256 verification failed for ${DEVOPS_CLOUDFLARED_PACKAGE_NAME}"
            rm -f "${tmp_bin}"
            return 1
        fi
    fi

    chmod +x "${tmp_bin}"
    mkdir -p "${DEVOPS_CLOUDFLARED_ROOT_BIN}"
    core::path::prepend "${DEVOPS_CLOUDFLARED_ROOT_BIN}"
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

function devops::cloudflared::internal::tunnel::create {
    local name="${1}"
    local port="${2}"
    local hostname="${3:-}"

    if [[ -z "${name}" || -z "${port}" ]]; then
        message_error "Usage: devops::cloudflared::tunnel::create <name> <port> [hostname]"
        return 1
    fi

    if [[ ! "${port}" =~ ^[0-9]+$ ]]; then
        message_error "Port must be a number: ${port}"
        return 1
    fi

    if ! core::exists cloudflared; then
        message_info "cloudflared not found, installing..."
        devops::cloudflared::internal::install || return 1
    fi

    if [[ ! -f "${DEVOPS_CLOUDFLARED_CONFIG_DIR}/cert.pem" ]]; then
        message_error "Not authenticated. Run 'cloudflared tunnel login' first."
        return 1
    fi

    local uuid
    uuid="$(cloudflared tunnel list 2>/dev/null | tail -n +2 | awk -v n="${name}" '$2 == n {print $1; exit}')"

    if [[ -z "${uuid}" ]]; then
        message_info "Creating tunnel ${name}"
        if ! cloudflared tunnel create "${name}"; then
            message_error "Failed to create tunnel ${name}"
            return 1
        fi
        uuid="$(cloudflared tunnel list 2>/dev/null | tail -n +2 | awk -v n="${name}" '$2 == n {print $1; exit}')"
    else
        message_info "Tunnel ${name} already exists (${uuid})"
    fi

    if [[ -z "${uuid}" ]]; then
        message_error "Could not resolve UUID for tunnel ${name}"
        return 1
    fi

    if [[ -n "${hostname}" ]]; then
        message_info "Routing DNS ${hostname} -> tunnel ${name}"
        if ! cloudflared tunnel route dns "${name}" "${hostname}"; then
            message_error "Failed to route DNS for ${hostname}"
            return 1
        fi
    fi

    local config_file="${DEVOPS_CLOUDFLARED_CONFIG_DIR}/config.yml"
    if [[ ! -f "${config_file}" ]]; then
        message_info "Scaffolding ${config_file}"
        mkdir -p "${DEVOPS_CLOUDFLARED_CONFIG_DIR}"
        if [[ -n "${hostname}" ]]; then
            cat > "${config_file}" <<EOF
tunnel: ${uuid}
credentials-file: ${DEVOPS_CLOUDFLARED_CONFIG_DIR}/${uuid}.json

ingress:
  - hostname: ${hostname}
    service: http://localhost:${port}
  - service: http_status:404
EOF
        else
            cat > "${config_file}" <<EOF
url: http://localhost:${port}
tunnel: ${uuid}
credentials-file: ${DEVOPS_CLOUDFLARED_CONFIG_DIR}/${uuid}.json
EOF
        fi
    fi

    message_success "Created tunnel ${name} (${uuid})"
    [[ -n "${hostname}" ]] && message_info "DNS: ${hostname} -> ${uuid}.cfargotunnel.com"
    message_info "Run with: cloudflared tunnel run ${name}"
}

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::cloudflared::internal::load {
    core::path::prepend "${DEVOPS_CLOUDFLARED_ROOT_BIN}"

    if ! core::exists cloudflared; then
        return
    fi
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
        if ! case "${OSTYPE}" in
        darwin*) echo "${DEVOPS_CLOUDFLARED_SHA256}  ${tmp_bin}" | shasum -a 256 -c - ;;
        *) echo "${DEVOPS_CLOUDFLARED_SHA256}  ${tmp_bin}" | sha256sum -c - ;;
        esac; then
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

function devops::cloudflared::internal::tunnel::resolve_uuid {
    local name="${1}"

    if core::exists jq; then
        cloudflared tunnel list -o json 2>/dev/null \
            | jq -r --arg n "${name}" '.[] | select(.name == $n) | .id' \
            | head -n1
    else
        message_warning "jq not found — falling back to fragile UUID parsing. Install jq for reliable output." >&2
        cloudflared tunnel list 2>/dev/null | tail -n +2 | awk -v n="${name}" '$2 == n {print $1; exit}'
    fi
}

function devops::cloudflared::internal::tunnel::check_port {
    local port="${1}"

    if command -v nc >/dev/null 2>&1; then
        nc -z localhost "${port}" 2>/dev/null
    elif command -v ss >/dev/null 2>&1; then
        ss -tln 2>/dev/null | grep -q ":${port} "
    else
        return 1
    fi
}

function devops::cloudflared::internal::tunnel::is_dns_routed {
    local name="${1}"
    local hostname="${2}"

    if command -v dig >/dev/null 2>&1; then
        local target="${name}.cfargotunnel.com"
        dig +short "${hostname}" 2>/dev/null | grep -qi "${target}"
    else
        return 1
    fi
}

function devops::cloudflared::internal::tunnel::ensure_dns_routed {
    local name="${1}"
    local hostname="${2}"

    if devops::cloudflared::internal::tunnel::is_dns_routed "${name}" "${hostname}"; then
        message_info "DNS already configured for ${hostname}"
        return 0
    fi

    message_info "Routing DNS ${hostname} -> tunnel ${name}"
    local route_output
    route_output="$(cloudflared tunnel route dns "${name}" "${hostname}" 2>&1)" || {
        if echo "${route_output}" | grep -qi "already exists"; then
            message_info "DNS already configured for ${hostname}"
            return 0
        fi
        message_error "Failed to route DNS for ${hostname}: ${route_output}"
        return 1
    }
}

function devops::cloudflared::internal::tunnel::write_config {
    local uuid="${1}"
    local port="${2}"
    local hostname="${3:-}"
    local config_file="${DEVOPS_CLOUDFLARED_CONFIG_DIR}/config.yml"

    mkdir -p "${DEVOPS_CLOUDFLARED_CONFIG_DIR}"

    if [[ ! -f "${config_file}" ]]; then
        message_info "Writing ${config_file}"
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
tunnel: ${uuid}
credentials-file: ${DEVOPS_CLOUDFLARED_CONFIG_DIR}/${uuid}.json

ingress:
  - service: http://localhost:${port}
  - service: http_status:404
EOF
        fi
        return 0
    fi

    # Config exists — add/update ingress rule additively
    local config_changed=false

    if [[ -n "${hostname}" ]]; then
        if grep -q "hostname: ${hostname}" "${config_file}" 2>/dev/null; then
            local current_port
            current_port="$(sed -n "/hostname: ${hostname}/,/service:/s|.*localhost:\([0-9]*\).*|\1|p" "${config_file}" 2>/dev/null | head -1 || true)"
            if [[ -n "${current_port}" && "${current_port}" != "${port}" ]]; then
                sed -i "/hostname: ${hostname}/,/service:/s|http://localhost:[0-9]*|http://localhost:${port}|" "${config_file}"
                config_changed=true
                message_info "Updated port for ${hostname}: ${current_port} -> ${port}"
            fi
        else
            sed -i "/http_status:404/i\\
  - hostname: ${hostname}\\
    service: http://localhost:${port}" "${config_file}"
            config_changed=true
            message_info "Added ingress rule for ${hostname} -> localhost:${port}"
        fi
    fi

    if [[ "${config_changed}" == true ]]; then
        message_info "Config updated"
    else
        message_info "Config unchanged — skipping rewrite"
    fi
}

function devops::cloudflared::internal::tunnel::create {
    local name="${1}"
    local port="${2}"
    local hostname="${3:-}"

    # Guard: validate inputs
    if [[ -z "${name}" || -z "${port}" ]]; then
        message_error "Usage: devops::cloudflared::tunnel::create <name> <port> [hostname]"
        return 1
    fi

    if [[ ! "${port}" =~ ^[0-9]+$ ]]; then
        message_error "Port must be a number: ${port}"
        return 1
    fi

    # Ensure cloudflared is installed
    if ! core::exists cloudflared; then
        message_info "cloudflared not found, installing..."
        devops::cloudflared::internal::install || return 1
    fi

    # Guard: authentication required
    if [[ ! -f "${DEVOPS_CLOUDFLARED_CONFIG_DIR}/cert.pem" ]]; then
        message_error "Not authenticated. Run 'cloudflared tunnel login' first."
        return 1
    fi

    # Advisory: port check
    if devops::cloudflared::internal::tunnel::check_port "${port}"; then
        message_warning "Port ${port} is already in use — proceeding anyway (service may start later)"
    fi

    # Resolve or create tunnel
    local uuid
    uuid="$(devops::cloudflared::internal::tunnel::resolve_uuid "${name}")"

    if [[ -z "${uuid}" ]]; then
        message_info "Creating tunnel ${name}"
        if ! cloudflared tunnel create "${name}"; then
            message_error "Failed to create tunnel ${name}"
            return 1
        fi
        uuid="$(devops::cloudflared::internal::tunnel::resolve_uuid "${name}")"
    else
        message_info "Tunnel ${name} already exists (${uuid})"
    fi

    # Guard: UUID must be resolved
    if [[ -z "${uuid}" ]]; then
        message_error "Could not resolve UUID for tunnel ${name}"
        return 1
    fi

    # Ensure DNS is routed
    if [[ -n "${hostname}" ]]; then
        devops::cloudflared::internal::tunnel::ensure_dns_routed "${name}" "${hostname}" || return 1
    fi

    # Write/update config
    devops::cloudflared::internal::tunnel::write_config "${uuid}" "${port}" "${hostname}"

    message_success "Created tunnel ${name} (${uuid})"
    [[ -n "${hostname}" ]] && message_info "DNS: ${hostname} -> ${uuid}.cfargotunnel.com"
    message_info "Run with: cloudflared tunnel run ${name}"
}

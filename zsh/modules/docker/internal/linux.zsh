#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Linux-specific Docker internal functions
# Sourced by internal/main.zsh after base.zsh when OSTYPE is linux*

function docker::internal::container::install {
    if core::exists docker; then
        return 0
    fi
    message_info "Installing Docker CE..."
    core::install docker
    core::install docker-compose

    # Enable and start systemd service
    if core::exists systemctl; then
        sudo systemctl enable --now docker 2>/dev/null || true
        sudo usermod -aG docker "${USER}" 2>/dev/null || true
    fi

    message_success "Docker CE installed."
}

function docker::internal::container::load {
    # Ensure systemd service is active
    if core::exists systemctl; then
        if ! systemctl is-active --quiet docker 2>/dev/null; then
            message_info "Starting Docker systemd service..."
            sudo systemctl start docker 2>/dev/null || true
        fi
        # Check user is in docker group
        if ! groups | grep -qw docker; then
            message_warning "User not in docker group — run: sudo usermod -aG docker ${USER}"
        fi
    fi

    # Detect docker-compose type
    if docker compose version &>/dev/null; then
        export DOCKER_COMPOSE_TYPE="plugin"
    elif docker-compose --version &>/dev/null; then
        export DOCKER_COMPOSE_TYPE="standalone"
    else
        message_warning "docker-compose not found — install via: sudo apt install docker-compose-plugin"
    fi
}

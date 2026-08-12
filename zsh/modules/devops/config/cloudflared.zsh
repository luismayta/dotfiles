#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Cloudflared configuration
export DEVOPS_CLOUDFLARED_PACKAGE_NAME=cloudflared
export DEVOPS_CLOUDFLARED_VERSION="2026.7.3"
export DEVOPS_CLOUDFLARED_DOWNLOAD_URL="https://github.com/cloudflare/cloudflared/releases/download/${DEVOPS_CLOUDFLARED_VERSION}/cloudflared-linux-amd64"
# Pinned SHA256 of the trusted binary (obtain once via: sha256sum cloudflared-linux-amd64).
# Left empty by default; verification is skipped when empty.
export DEVOPS_CLOUDFLARED_SHA256=""
export DEVOPS_CLOUDFLARED_ROOT_BIN="${HOME}/.local/bin"
export DEVOPS_CLOUDFLARED_BIN="${DEVOPS_CLOUDFLARED_ROOT_BIN}/cloudflared"
export DEVOPS_CLOUDFLARED_CONFIG_DIR="${HOME}/.cloudflared"

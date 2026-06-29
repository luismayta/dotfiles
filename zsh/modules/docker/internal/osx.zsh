#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# macOS-specific Docker internal functions
# Sourced by internal/main.zsh after base.zsh when OSTYPE is darwin*

function docker::internal::container::install {
    # Check if Docker Desktop is installed as an app
    if [[ -d "/Applications/Docker.app" ]]; then
        message_info "Docker Desktop.app found at /Applications/Docker.app"
        return 0
    fi
    # Fallback: install Docker via Homebrew
    docker::internal::container::install::provider docker
}

function docker::internal::container::load {
    # If Docker Desktop app exists but is not running, launch it
    if [[ -d "/Applications/Docker.app" ]]; then
        if ! pgrep -q "Docker"; then
            message_info "Starting Docker Desktop.app..."
            open -a Docker
            # Give it a moment to start before we return
            sleep 2
        fi
        return 0
    fi
    # For other providers (orbstack, colima, etc.), load is handled
    # by their respective provider files
    return 0
}

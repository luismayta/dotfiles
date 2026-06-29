#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::login {
    message_info "Authenticating with Docker Hub..."
    echo -n "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
}

function docker::internal::clean::all {
    docker system prune --all --force --volumes
}

function docker::internal::images::delete::dangling {
    docker images -q -f "dangling=true" | xargs docker image rm -f
}

function docker::internal::images::delete::all {
    docker image ls -a -q | xargs docker image rm -f
}

function docker::internal::process::list {
    docker ps "$@"
}

function docker::internal::process::stop::exited {
    docker ps -q -f "status=exited" | xargs docker rm
}

function docker::internal::process::delete::all {
    docker ps -a -q | xargs docker rm
}

function docker::internal::volume::list::all {
    docker volume ls
}

function docker::internal::volume::delete::exited {
    docker ps -q -f "status=exited" | xargs docker rm -v
}

function docker::internal::volume::delete::all {
    docker volume ls -q | xargs docker volume rm -f
}

function docker::internal::volume::delete::dangling {
    docker volume ls -q -f "dangling=true" | xargs docker volume rm -f
}

function docker::internal::container::delete::all {
    docker container ls -a -q | xargs docker container stop
    docker container ls -a -q | xargs docker container rm
}

function docker::internal::container::install::provider {
    local provider="$1"
    if core::exists "$provider"; then return; fi
    message_info "Installing ${DOCKER_PACKAGE_NAME}"
    core::install "$provider"
    message_success "Installed ${DOCKER_PACKAGE_NAME}"
}

function docker::internal::container::stop::all {
    docker ps -q -f "status=running" | xargs docker stop
}

function docker::internal::container::stop::dangling {
    docker ps -q -f "status=exited" | xargs docker rm
}

function docker::internal::network::delete::all {
    docker network ls -q | xargs docker network rm -f
}

# ---------------------------------------------------------------------------
# DOCKER_HOST auto-resolution
# ---------------------------------------------------------------------------

function docker::internal::resolve::socket {
    # If user already set DOCKER_HOST explicitly, respect it
    if [[ -n "${DOCKER_HOST:-}" ]]; then
        return 0
    fi

    # Dynamic dispatch to adapter-level strategy hook.
    # Each config/adapter/*.zsh defines docker::adapter::resolve::socket
    # with provider-specific socket resolution logic.
    if (( ${+functions[docker::adapter::resolve::socket]} )); then
        docker::adapter::resolve::socket
    fi

    # Fallback: use DOCKER_SOCKET_PATH if set by user
    if [[ -z "${DOCKER_HOST:-}" && -n "${DOCKER_SOCKET_PATH:-}" && -S "${DOCKER_SOCKET_PATH}" ]]; then
        export DOCKER_HOST="unix://${DOCKER_SOCKET_PATH}"
    fi
}

# ---------------------------------------------------------------------------
# Health check
# ---------------------------------------------------------------------------

function docker::internal::health::check {
    # Non-blocking health check — warns if Docker is unreachable
    if docker info &>/dev/null; then
        export DOCKER_IS_RUNNING=true
        message_success "Docker daemon is running (${DOCKER_CONTAINER_APP_NAME})"
    else
        export DOCKER_IS_RUNNING=false
        message_warning "Docker daemon (${DOCKER_CONTAINER_APP_NAME}) is not running or not reachable"
    fi
}

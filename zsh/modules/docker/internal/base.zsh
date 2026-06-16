#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::login {
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

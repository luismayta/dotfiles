#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::container::install {
  if [[ "${OSTYPE}" == linux* ]]; then
    if core::exists docker; then return; fi
    core::install docker
    core::install docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker "${USER}"
    docker run hello-world
  else
    docker::internal::container::install::provider docker
  fi
}

function docker::internal::container::load {
  return
}

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::container::install {
  docker::internal::container::install::provider podman
}

function docker::internal::container::load {
  local machine_name="${DOCKER_PODMAN_MACHINE_NAME:-podman-machine-default}"

  if ! command -v jq >/dev/null 2>&1; then
    echo "❌ 'jq' is required but not installed. Please install it with: brew install jq"; return 1
  fi

  if ! podman machine list | grep -q "${machine_name}"; then
    echo "🔧 Podman machine '${machine_name}' not found. Initializing..."
    podman machine init --now --name "${machine_name}"; return
  fi

  local running
  running=$(podman machine list --format json | jq -r \
    --arg name "$machine_name" '.[] | select(.Name == $name) | .Running')

  if [[ "${running}" != "true" ]]; then
    echo "🚀 Podman machine '${machine_name}' exists but is not running. Starting..."
    podman machine start "${machine_name}"
  fi
}

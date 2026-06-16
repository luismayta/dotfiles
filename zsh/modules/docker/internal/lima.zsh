#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::container::install {
  docker::internal::container::install::provider lima
}

function docker::internal::container::load {
  local machine_name="${DOCKER_LIMA_MACHINE_NAME:-default}"

  if ! command -v jq >/dev/null 2>&1; then
    echo "❌ 'jq' is required but not installed. Please install it with: brew install jq"; return 1
  fi

  if ! limactl list --json | jq -e --arg name "$machine_name" '.[] | select(.name == $name)' >/dev/null; then
    echo "🔧 Lima machine '${machine_name}' does not exist. Initializing..."
    limactl start "$machine_name"; return
  fi

  local running
  running=$(limactl list --json | jq -r --arg name "$machine_name" '.[] | select(.name == $name) | .state')

  if [[ "$running" != "Running" ]]; then
    echo "🚀 Lima machine '${machine_name}' exists but is not running. Starting..."
    limactl start "$machine_name"
  else
    echo "✅ Lima machine '${machine_name}' is already running."
  fi
}

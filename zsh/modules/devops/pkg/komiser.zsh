#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::komiser::sync {
  local src="${DEVOPS_PATH}/data/komiser/"
  local dst="${DEVOPS_KOMISER_CONF_PATH}/"

  message_info "Syncing komiser data"
  rsync -avzh --progress "${src}" "${dst}"
  message_success "Sync complete"
}

function devops::komiser {
  devops::komiser::sync

  mkdir -p "${DEVOPS_KOMISER_CONF_PATH}"

  local config_file="${DEVOPS_KOMISER_CONF_PATH}/config.toml"

  if [[ ! -f "${config_file}" ]]; then
    cat > "${config_file}" <<'EOF'
[[aws]]
name = "default"
source = "ENVIRONMENT_VARIABLES"

[sqlite]
file = "/data/komiser.db"
EOF
  fi

  message_info "Komiser is running at http://localhost:${DEVOPS_KOMISER_PORT}"
  docker run --rm -d -p "${DEVOPS_KOMISER_PORT}:3000" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    -v "${DEVOPS_KOMISER_CONF_PATH}:/data" \
    -v "${DEVOPS_KOMISER_CONF_PATH}/config.toml:/config.toml:ro" \
    --name komiser tailwarden/komiser:3.1.22 start --config /config.toml
}

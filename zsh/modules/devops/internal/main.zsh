#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/base.zsh"


# Tool internal layers
# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/k9s.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/kubectl.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/helm.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/tfenv.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/gcloud.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/atuin.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/bruno.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/docker-compose.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/cloudflared.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/caddy.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/worktrunk.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/direnv.zsh"

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/internal/osx.zsh"
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/internal/linux.zsh"
    ;;
esac
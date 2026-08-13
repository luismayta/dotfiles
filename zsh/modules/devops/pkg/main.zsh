#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/base.zsh"

# Tool package layers
# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/k9s.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/kubectl.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/helm.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/tfenv.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/komiser.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/sync.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/aws.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/gcloud.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/atuin.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/bruno.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/docker-compose.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/cloudflared.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/caddy.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/worktrunk.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/direnv.zsh"
case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/pkg/osx.zsh"
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/pkg/linux.zsh"
    ;;
esac


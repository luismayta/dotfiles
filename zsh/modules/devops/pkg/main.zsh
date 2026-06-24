#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/base.zsh"

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
source "${DEVOPS_PATH}/pkg/aws.zsh"


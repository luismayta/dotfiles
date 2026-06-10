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

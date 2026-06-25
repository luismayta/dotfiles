#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

export DEVOPS_PACKAGE_NAME=devops

# Komiser configuration
export DEVOPS_KOMISER_PORT=9090
export DEVOPS_KOMISER_CONF_PATH="${HOME}/.config/komiser"

export DEVOPS_TOOLS=(
  sops
  packer
  telepresenceio/telepresence/telepresence-oss
  k9s
  kubectl
  helm
  tfenv
  terragrunt
  terraform-docs
  glab
  github-cli
  yazi
  zoxide
)

export DEVOPS_PACKAGES=(
    "${DEVOPS_TOOLS[@]}"
)

# K9S configuration
export DEVOPS_K9S_PACKAGE_NAME=k9s
export DEVOPS_K9S_CONF_PATH=${HOME}/Library/Application\ Support/k9s
export DEVOPS_K9S_FILE_SETTINGS="${DEVOPS_K9S_CONF_PATH}"/config.yml

# Kubectl configuration
export DEVOPS_KUBECTL_PACKAGE_NAME=kubectl
export DEVOPS_KUBECTL_MESSAGE_GO_NOT_FOUND="Please install Go or use antibody bundle hadenlabs/zsh-goenv"
# NOTE: LOCAL_PATH_BIN is provided by zsh/core/config/paths.zsh
# NOTE: EDITOR is provided by zsh/core/config/env.zsh

export KREW_ROOT="${HOME}/.krew"
export KREW_ROOT_BIN="${KREW_ROOT}/bin"

export KREW_PLUGINS=(
    ctx
    ns
    access-matrix
    ktop
    ca-cert
    cert-manager
    cluster-group
    debug-shell
    df-pv
    fuzzy
    get-all
    images
    krew
    mtail
    neat
    net-forward
    node-admin
    node-restart
    node-shell
    oidc-login
    open-svc
    outdated
    resource-capacity
    socks5-proxy
    tree
    view-secret
    who-can
    schemahero
    deprecations
    sniff
)

export DEVOPS_KUBECTL_GO_PACKAGES=(
    github.com/aquasecurity/kubectl-who-can
)

export DEVOPS_KUBECTL_GO_INSTALL=(
    github.com/particledecay/kconf@latest
    sigs.k8s.io/kustomize/kustomize/v4@latest
    golang.stackrox.io/kube-linter/cmd/kube-linter@latest
)

export DEVOPS_GO_PACKAGES=(
  github.com/direnv/direnv/v2@latest
  github.com/hashicorp/hcl/v2/cmd/hclfmt@latest
)

# Helm configuration
export DEVOPS_HELM_PACKAGE_NAME=helm

# Tfenv configuration
export DEVOPS_TFENV_ROOT="${HOME}/.tfenv"
export DEVOPS_TFENV_ROOT_BIN="${DEVOPS_TFENV_ROOT}/bin"
export DEVOPS_TFENV_PACKAGE_NAME=tfenv
export TF_PLUGIN_CACHE_PATH="${HOME}"/.terraform.d/plugin-cache
export DEVOPS_TFENV_VERSIONS=(
    1.0.1
    1.11.4
)
export DEVOPS_TFENV_VERSION_GLOBAL=1.11.4
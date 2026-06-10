#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: base.zsh
# Description: goenv module environment variables and configuration
# ==============================================================================
# shellcheck shell=bash

export GO111MODULES=auto
export GOENV_ROOT="${HOME}/.goenv"
export GOENV_ROOT_BIN="${GOENV_ROOT}/bin"
export GOBREW_ROOT_BIN="${HOME}/.gobrew/bin"
export GOBREW_CURRENT_BIN="${HOME}/.gobrew/current/bin"
export GOBREW_DOWNLOAD_URL="https://raw.githubusercontent.com/kevincobain2000/gobrew/master/git.io.sh"
export GOENV_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew"
export GOENV_PACKAGE_NAME=goenv
export ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH=go1.21
export GOENV_VERSIONS=(
  1.24.11
  1.25.11
)
export GOENV_VERSION_GLOBAL="${JASPER_GOENV_VERSION_GLOBAL:-1.25.11}"

# Kubernetes
GOENV_INSTALL_PACKAGES+=(
  k8s.io/kubernetes/cmd/kubectl
  k8s.io/kubernetes/cmd/kubelet
  k8s.io/kubernetes/cmd/kubeadm
  github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
)

# Go Development
GOENV_INSTALL_PACKAGES+=(
  github.com/nsf/gocode
  github.com/uudashr/gopkgs/v2/cmd/gopkgs
  github.com/ramya-rao-a/go-outline
  github.com/acroca/go-symbols
  github.com/fatih/gomodifytags
  github.com/josharian/impl
  github.com/haya14busa/goplay/cmd/goplay
  github.com/go-delve/delve/cmd/dlv
  golang.org/x/tools/gopls
  golang.org/x/tools/cmd/guru
  golang.org/x/tools/cmd/gorename
  golang.org/x/tools/cmd/godoc
  golang.org/x/tools/cmd/goimports
  golang.org/x/tools/cmd/gomvpkg
  golang.org/x/tools/cmd/gorename
  golang.org/x/tools/cmd/gotype
  golang.org/x/tools/cmd/goyacc
  golang.org/x/tools/cmd/stringer
  golang.org/x/lint/golint
)

# Testing
GOENV_INSTALL_PACKAGES+=(
  github.com/cweill/gotests/gotests
)

# API Documentation
GOENV_INSTALL_PACKAGES+=(
  github.com/swaggo/swag/cmd/swag
)

# Dependency Injection
GOENV_INSTALL_PACKAGES+=(
  github.com/google/wire/cmd/wire
)

# Release & Build
GOENV_INSTALL_PACKAGES+=(
  github.com/goreleaser/goreleaser
  github.com/goreleaser/nfpm/v2/cmd/nfpm
)

# Git & SCM
GOENV_INSTALL_PACKAGES+=(
  github.com/x-motemen/ghq
)

# Quality & Linters
GOENV_INSTALL_PACKAGES+=(
  github.com/golangci/golangci-lint/cmd/golangci-lint
)

# Security
GOENV_INSTALL_PACKAGES+=(
  github.com/securego/gosec/v2/cmd/gosec
)

# Infrastructure
GOENV_INSTALL_PACKAGES+=(
  github.com/terraform-docs/terraform-docs
)

# YAML/TOML
GOENV_INSTALL_PACKAGES+=(
  github.com/BurntSushi/toml/cmd/tomlv
)

# Templates & Config
GOENV_INSTALL_PACKAGES+=(
  github.com/willfaught/conf
)

# Debugging
GOENV_INSTALL_PACKAGES+=(
  github.com/nicksnyder/go-i18n/v2/goi18n
)

# Networking
GOENV_INSTALL_PACKAGES+=(
  github.com/miekg/dns
)

# Discovery
GOENV_INSTALL_PACKAGES+=(
  github.com/hashicorp/consul/api
)

# Productivity
GOENV_INSTALL_PACKAGES+=(
  github.com/knqyf263/pet
)

# Misc
GOENV_INSTALL_PACKAGES+=(
  github.com/Masterminds/glide
  github.com/golang/mock/mockgen
  github.com/golang/protobuf/protoc-gen-go
  github.com/micro/protoc-gen-micro
)

#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Declarative package lists — edit this file to add/remove packages
# Sourced by both install.sh (bootstrap) and provision scripts
# shellcheck disable=SC2034 # consumed by sourcing scripts

PACKAGES_COMMON=(ksh zsh)
PACKAGES_MAC=(ag cmake font-source-code-pro)
PACKAGES_LINUX=(go npm yarn gcc ttf-jetbrains-mono-nerd mise devbox-bin starship)
PACKAGES_APT=(git curl build-essential software-properties-common zsh mise)
PACKAGES_APT_REPOS=(ppa:jdxcode/mise)

readonly PACKAGES_COMMON PACKAGES_MAC PACKAGES_LINUX PACKAGES_APT PACKAGES_APT_REPOS

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: base.zsh
# Description: apps module environment variables and configuration
# ==============================================================================
# shellcheck shell=bash

export APPS_PACKAGE_NAME=apps
export APPS_APPLICATION_PATH="/Applications"
APPS_ARCHITECTURE_NAME="${OSTYPE}-$(uname -m)"
export APPS_ARCHITECTURE_NAME

# ==============================================================================
# IDE Tools
# ==============================================================================
APPS_IDE_TOOLS__DARWIN=(tig meld)
APPS_IDE_TOOLS__LINUX=(tig meld)                    # official extra

# ==============================================================================
# JetBrains
# ==============================================================================
APPS_JETBRAINS__DARWIN=(intellij-idea-ce)
APPS_JETBRAINS__LINUX=(intellij-idea-community-edition)  # AUR + official

# ==============================================================================
# Communication
# ==============================================================================
APPS_COMMUNICATION__DARWIN=(discord)
APPS_COMMUNICATION__LINUX=(discord)                  # AUR

# ==============================================================================
# Knowledge
# ==============================================================================
APPS_KNOWLEDGE__DARWIN=(obsidian drawio)
APPS_KNOWLEDGE__LINUX=(obsidian-bin drawio-desktop)   # AUR + official

# ==============================================================================
# DevOps
# ==============================================================================
APPS_DEVOPS__DARWIN=(multipass ngrok)
APPS_DEVOPS__LINUX=(canonical-multipass ngrok)       # AUR

# ==============================================================================
# Database Clients
# ==============================================================================
APPS_DATABASE_CLIENTS__DARWIN=(dbeaver-community datagrip)
APPS_DATABASE_CLIENTS__LINUX=(dbeaver datagrip)  # official + AUR

# ==============================================================================
# Browser
# ==============================================================================
APPS_BROWSER__DARWIN=(brave-browser)
APPS_BROWSER__LINUX=(brave-bin)                      # AUR

# ==============================================================================
# Android
# ==============================================================================
APPS_ANDROID__DARWIN=(android-studio android-platform-tools)
APPS_ANDROID__LINUX=(android-studio android-platform-tools)  # all AUR

# ==============================================================================
# Mobile
# ==============================================================================
APPS_MOBILE__DARWIN=(watchman fastlane)
APPS_MOBILE__LINUX=(watchman-bin)                    # AUR (fastlane is ruby gem, no package)

# ==============================================================================
# VPN Clients
# ==============================================================================
APPS_VPN_CLIENTS__DARWIN=(openvpn)
APPS_VPN_CLIENTS__LINUX=(openvpn)    # official

# ==============================================================================
# Project Management
# ==============================================================================
APPS_PROJECT_MANAGEMENT__DARWIN=(jira-cli)
APPS_PROJECT_MANAGEMENT__LINUX=(jira-cli)            # AUR

# ==============================================================================
# Web Apps
# ==============================================================================
APPS_WEB_APPS__DARWIN=(pake)
APPS_WEB_APPS__LINUX=()                              # pake via cargo, no Arch package

# ==============================================================================
# OS resolution: select correct names based on OSTYPE
# ==============================================================================
if [[ "${OSTYPE}" =~ ^darwin ]]; then
  APPS_IDE_TOOLS=("${APPS_IDE_TOOLS__DARWIN[@]}")
  APPS_JETBRAINS=("${APPS_JETBRAINS__DARWIN[@]}")
  APPS_COMMUNICATION=("${APPS_COMMUNICATION__DARWIN[@]}")
  APPS_KNOWLEDGE=("${APPS_KNOWLEDGE__DARWIN[@]}")
  APPS_DEVOPS=("${APPS_DEVOPS__DARWIN[@]}")
  APPS_DATABASE_CLIENTS=("${APPS_DATABASE_CLIENTS__DARWIN[@]}")
  APPS_BROWSER=("${APPS_BROWSER__DARWIN[@]}")
  APPS_ANDROID=("${APPS_ANDROID__DARWIN[@]}")
  APPS_MOBILE=("${APPS_MOBILE__DARWIN[@]}")
  APPS_VPN_CLIENTS=("${APPS_VPN_CLIENTS__DARWIN[@]}")
  APPS_PROJECT_MANAGEMENT=("${APPS_PROJECT_MANAGEMENT__DARWIN[@]}")
  APPS_WEB_APPS=("${APPS_WEB_APPS__DARWIN[@]}")
elif [[ "${OSTYPE}" =~ ^linux ]]; then
  APPS_IDE_TOOLS=("${APPS_IDE_TOOLS__LINUX[@]}")
  APPS_JETBRAINS=("${APPS_JETBRAINS__LINUX[@]}")
  APPS_COMMUNICATION=("${APPS_COMMUNICATION__LINUX[@]}")
  APPS_KNOWLEDGE=("${APPS_KNOWLEDGE__LINUX[@]}")
  APPS_DEVOPS=("${APPS_DEVOPS__LINUX[@]}")
  APPS_DATABASE_CLIENTS=("${APPS_DATABASE_CLIENTS__LINUX[@]}")
  APPS_BROWSER=("${APPS_BROWSER__LINUX[@]}")
  APPS_ANDROID=("${APPS_ANDROID__LINUX[@]}")
  APPS_MOBILE=("${APPS_MOBILE__LINUX[@]}")
  APPS_VPN_CLIENTS=("${APPS_VPN_CLIENTS__LINUX[@]}")
  APPS_PROJECT_MANAGEMENT=("${APPS_PROJECT_MANAGEMENT__LINUX[@]}")
  APPS_WEB_APPS=("${APPS_WEB_APPS__LINUX[@]}")
else
  # Fallback to Darwin names for unknown OS
  APPS_IDE_TOOLS=("${APPS_IDE_TOOLS__DARWIN[@]}")
  APPS_JETBRAINS=("${APPS_JETBRAINS__DARWIN[@]}")
  APPS_COMMUNICATION=("${APPS_COMMUNICATION__DARWIN[@]}")
  APPS_KNOWLEDGE=("${APPS_KNOWLEDGE__DARWIN[@]}")
  APPS_DEVOPS=("${APPS_DEVOPS__DARWIN[@]}")
  APPS_DATABASE_CLIENTS=("${APPS_DATABASE_CLIENTS__DARWIN[@]}")
  APPS_BROWSER=("${APPS_BROWSER__DARWIN[@]}")
  APPS_ANDROID=("${APPS_ANDROID__DARWIN[@]}")
  APPS_MOBILE=("${APPS_MOBILE__DARWIN[@]}")
  APPS_VPN_CLIENTS=("${APPS_VPN_CLIENTS__DARWIN[@]}")
  APPS_PROJECT_MANAGEMENT=("${APPS_PROJECT_MANAGEMENT__DARWIN[@]}")
  APPS_WEB_APPS=("${APPS_WEB_APPS__DARWIN[@]}")
fi

export APPS_PACKAGES=(
    "${APPS_IDE_TOOLS[@]}"
    "${APPS_VPN_CLIENTS[@]}"
    "${APPS_JETBRAINS[@]}"
    "${APPS_COMMUNICATION[@]}"
    "${APPS_KNOWLEDGE[@]}"
    "${APPS_DEVOPS[@]}"
    "${APPS_BROWSER[@]}"
    "${APPS_ANDROID[@]}"
    "${APPS_MOBILE[@]}"
    "${APPS_DATABASE_CLIENTS[@]}"
    "${APPS_PROJECT_MANAGEMENT[@]}"
    "${APPS_WEB_APPS[@]}"
)
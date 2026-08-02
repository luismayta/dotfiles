#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ---------------------------------------------------------------------------
# macOS-specific cleanup paths
# Organized by function category — system, adobe, ios, xcode
# ---------------------------------------------------------------------------

# ── System: Trash ──────────────────────────────────────────────────────────
# Empty the Trash on all mounted volumes
export ZSH_CLEAN_OSX_TRASH_VOLUMES="/Volumes/*/.Trashes"

# Empty the Trash on the main HDD
export ZSH_CLEAN_OSX_TRASH_MAIN="${HOME}/.Trash"

# ── System: Logs ───────────────────────────────────────────────────────────
# Clear Mail.app logs
export ZSH_CLEAN_OSX_LOG_MAIL="${HOME}/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"

# Clear CoreSimulator logs
export ZSH_CLEAN_OSX_LOG_CORE_SIMULATOR="${HOME}/Library/Logs/CoreSimulator"

# ── Adobe Cache ────────────────────────────────────────────────────────────
# Clear Adobe Media Cache directory
export ZSH_CLEAN_OSX_ADOBE_CACHE="${HOME}/Library/Application Support/Adobe/Common/Media Cache Files"

# ── iOS Applications ───────────────────────────────────────────────────────
# Remove archived iOS applications from iTunes
export ZSH_CLEAN_OSX_IOS_APPLICATIONS="${HOME}/Music/iTunes/iTunes Media/Mobile Applications"

# ── iOS Device Backups ─────────────────────────────────────────────────────
# Remove iOS device backups
export ZSH_CLEAN_OSX_IOS_DEVICE_BACKUP="${HOME}/Library/Application Support/MobileSync/Backup"

# ── Xcode ──────────────────────────────────────────────────────────────────
# Remove Xcode Derived Data (project build artifacts)
export ZSH_CLEAN_OSX_XCODE_DERIVED_DATA="${HOME}/Library/Developer/Xcode/DerivedData"

# Remove Xcode Archives (archived builds)
export ZSH_CLEAN_OSX_XCODE_ARCHIVES="${HOME}/Library/Developer/Xcode/Archives"

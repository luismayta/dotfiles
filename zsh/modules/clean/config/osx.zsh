#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ---------------------------------------------------------------------------
# macOS-specific cleanup paths
# Organized by function category — system, adobe, ios, xcode
# ---------------------------------------------------------------------------

# ── System: Trash ──────────────────────────────────────────────────────────
# Empty the Trash on all mounted volumes
export ZSH_CLEAN_OSX_TRASH_VOLUMES="/Volumes/*/.Trashes"
export CLEAN_OSX_TRASH_VOLUMES="${ZSH_CLEAN_OSX_TRASH_VOLUMES}"  # remove in next cleanup cycle

# Empty the Trash on the main HDD
export ZSH_CLEAN_OSX_TRASH_MAIN="${HOME}/.Trash"
export CLEAN_OSX_TRASH_MAIN="${ZSH_CLEAN_OSX_TRASH_MAIN}"  # remove in next cleanup cycle

# ── System: Logs ───────────────────────────────────────────────────────────
# Clear Mail.app logs
export ZSH_CLEAN_OSX_LOG_MAIL="${HOME}/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"
export CLEAN_OSX_LOG_MAIL="${ZSH_CLEAN_OSX_LOG_MAIL}"  # remove in next cleanup cycle

# Clear CoreSimulator logs
export ZSH_CLEAN_OSX_LOG_CORE_SIMULATOR="${HOME}/Library/Logs/CoreSimulator"
export CLEAN_OSX_LOG_CORE_SIMULATOR="${ZSH_CLEAN_OSX_LOG_CORE_SIMULATOR}"  # remove in next cleanup cycle

# ── Adobe Cache ────────────────────────────────────────────────────────────
# Clear Adobe Media Cache directory
export ZSH_CLEAN_OSX_ADOBE_CACHE="${HOME}/Library/Application Support/Adobe/Common/Media Cache Files"
export CLEAN_OSX_ADOBE_CACHE="${ZSH_CLEAN_OSX_ADOBE_CACHE}"  # remove in next cleanup cycle

# ── iOS Applications ───────────────────────────────────────────────────────
# Remove archived iOS applications from iTunes
export ZSH_CLEAN_OSX_IOS_APPLICATIONS="${HOME}/Music/iTunes/iTunes Media/Mobile Applications"
export CLEAN_OSX_IOS_APPLICATIONS="${ZSH_CLEAN_OSX_IOS_APPLICATIONS}"  # remove in next cleanup cycle

# ── iOS Device Backups ─────────────────────────────────────────────────────
# Remove iOS device backups
export ZSH_CLEAN_OSX_IOS_DEVICE_BACKUP="${HOME}/Library/Application Support/MobileSync/Backup"
export CLEAN_OSX_IOS_DEVICE_BACKUP="${ZSH_CLEAN_OSX_IOS_DEVICE_BACKUP}"  # remove in next cleanup cycle

# ── Xcode ──────────────────────────────────────────────────────────────────
# Remove Xcode Derived Data (project build artifacts)
export ZSH_CLEAN_OSX_XCODE_DERIVED_DATA="${HOME}/Library/Developer/Xcode/DerivedData"
export CLEAN_OSX_XCODE_DERIVED_DATA="${ZSH_CLEAN_OSX_XCODE_DERIVED_DATA}"  # remove in next cleanup cycle

# Remove Xcode Archives (archived builds)
export ZSH_CLEAN_OSX_XCODE_ARCHIVES="${HOME}/Library/Developer/Xcode/Archives"
export CLEAN_OSX_XCODE_ARCHIVES="${ZSH_CLEAN_OSX_XCODE_ARCHIVES}"  # remove in next cleanup cycle

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function cleanup::system::trash {
    message_info "Empty the Trash on all mounted volumes and the main HDD..."
    [[ -n "${CLEAN_OSX_TRASH_VOLUMES}" ]] && _cleanup::safe_remove "${CLEAN_OSX_TRASH_VOLUMES}"
    [[ -n "${CLEAN_OSX_TRASH_MAIN}" ]] && _cleanup::safe_remove "${CLEAN_OSX_TRASH_MAIN}"
    message_success "Empty the Trash on all mounted volumes and the main HDD..."
}

function cleanup::system::logs {
    message_info "Clear System Log Files..."
    [[ -n "${CLEAN_OSX_LOG_MAIL}" ]] && _cleanup::safe_remove "${CLEAN_OSX_LOG_MAIL}"
    [[ -n "${CLEAN_OSX_LOG_CORE_SIMULATOR}" ]] && _cleanup::safe_remove "${CLEAN_OSX_LOG_CORE_SIMULATOR}"
    message_success "Clear System Log Files..."
}

function cleanup::osx::adobe_cache {
    message_info "Clear Adobe Cache Files..."
    [[ -n "${CLEAN_OSX_ADOBE_CACHE}" ]] && _cleanup::safe_remove "${CLEAN_OSX_ADOBE_CACHE}"
    message_success "Clear Adobe Cache Files..."
}

function cleanup::osx::ios_application {
    message_info "Cleanup iOS Applications..."
    [[ -n "${CLEAN_OSX_IOS_APPLICATIONS}" ]] && _cleanup::safe_remove "${CLEAN_OSX_IOS_APPLICATIONS}"
    message_success "Cleanup iOS Applications..."
}

function cleanup::osx::ios_device_backup {
    message_info "Remove iOS Device Backups..."
    [[ -n "${CLEAN_OSX_IOS_DEVICE_BACKUP}" ]] && _cleanup::safe_remove "${CLEAN_OSX_IOS_DEVICE_BACKUP}"
    message_success "Remove iOS Device Backups..."
}

function cleanup::osx::xcode {
    message_info "Cleanup XCode Derived Data and Archives..."
    [[ -n "${CLEAN_OSX_XCODE_DERIVED_DATA}" ]] && _cleanup::safe_remove "${CLEAN_OSX_XCODE_DERIVED_DATA}"
    [[ -n "${CLEAN_OSX_XCODE_ARCHIVES}" ]] && _cleanup::safe_remove "${CLEAN_OSX_XCODE_ARCHIVES}"
    message_success "Cleanup XCode Derived Data and Archives..."
}

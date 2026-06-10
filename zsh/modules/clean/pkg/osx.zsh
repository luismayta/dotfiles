#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function cleanup::system::trash {
    message_info "Empty the Trash on all mounted volumes and the main HDD..."
    local volume_trashs="/Volumes/*/.Trashes/*"
    local trashs="${HOME}/.Trash/*"
    [ -e "${volume_trashs}" ] && rm -rfv "${volume_trashs}" > /dev/null 2>&1
    [ -e "${trashs}" ] && rm -rfv "${trashs}" > /dev/null 2>&1
    message_success "Empty the Trash on all mounted volumes and the main HDD..."
}

function cleanup::system::logs {
    message_info "Clear System Log Files..."
    local mail_logs="${HOME}/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/"
    local core_simulator="${HOME}/Library/Logs/CoreSimulator/*"
    [ -e "${mail_logs}" ] && rm -rfv "${mail_logs}" > /dev/null 2>&1
    [ -e "${core_simulator}" ] && rm -rfv "${core_simulator}" > /dev/null 2>&1
    message_success "Clear System Log Files..."
}

function cleanup::adobe_cache {
    message_info "Clear Adobe Cache Files..."
    local adobe_cache="${HOME}/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/*"
    [ -e "${adobe_cache}" ] && rm -rfv "${adobe_cache}" > /dev/null 2>&1
    message_success "Clear Adobe Cache Files..."
}

function cleanup::ios_application {
    message_info "Cleanup iOS Applications..."
    local itunes_applications="${HOME}/Music/iTunes/iTunes\ Media/Mobile\ Applications/*"
    [ -e "${itunes_applications}" ] && rm -rfv "${itunes_applications}" > /dev/null 2>&1
    message_success "Cleanup iOS Applications..."
}

function cleanup::ios_device_backup {
    message_info "Remove iOS Device Backups..."
    local mobile_backup="${HOME}/Library/Application\ Support/MobileSync/Backup/*"
    [ -e "${mobile_backup}" ] && rm -rfv "${mobile_backup}" > /dev/null 2>&1
    message_success "Remove iOS Device Backups..."
}

function cleanup::xcode {
    message_info "Cleanup XCode Derived Data and Archives..."
    local xcode_data="${HOME}/Library/Developer/Xcode/DerivedData/*"
    local xcode_archive="${HOME}/Library/Developer/Xcode/Archives/*"
    [ -e "${xcode_data}" ] && rm -rfv "${xcode_data}" > /dev/null 2>&1
    [ -e "${xcode_archive}" ] && rm -rfv "${xcode_archive}" > /dev/null 2>&1
    message_success "Cleanup XCode Derived Data and Archives..."
}

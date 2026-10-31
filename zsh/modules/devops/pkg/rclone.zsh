#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::rclone::install {
    devops::rclone::internal::install
}

function devops::rclone::upgrade {
    devops::rclone::internal::upgrade
}

function devops::rclone::post_install {
    message_info "Rclone usage guidance:"
    message_info "  rclone config       # create or edit remotes (S3, Google Drive, SFTP, ...)"
    message_info "  rclone listremotes  # list configured remotes"
    message_info "  rclone ls remote:path  # list files on a remote"
}

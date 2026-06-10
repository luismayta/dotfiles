#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function starship::load {
    starship::internal::load
}

function starship::dependences {
    message_info "Installing dependences for ${STARSHIP_PACKAGE_NAME}"
    message_success "Installed dependences for ${STARSHIP_PACKAGE_NAME}"
}

function starship::install {
    starship::dependences
    message_info "Installing ${STARSHIP_PACKAGE_NAME}"
    starship::internal::starship::install
    message_success "Installed ${STARSHIP_PACKAGE_NAME}"
}

function starship::post_install {
    message_info "Post Install ${STARSHIP_PACKAGE_NAME}"
    starship::sync
    message_success "Success Install ${STARSHIP_PACKAGE_NAME}"
}

function starship::sync {
    rsync -avzh --progress "${ZSH_STARSHIP_PATH}/conf/" "${ZSH_HOME_CONF_DIR}/"
}

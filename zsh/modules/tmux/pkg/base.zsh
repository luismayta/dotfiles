# shellcheck shell=bash

function tmux::install {
    tmux::internal::tmux::install
}

function tmux::post_install {
    message_info "Post Install ${TMUX_PACKAGE_NAME}"
    tmux::sync
    message_success "Success Install ${TMUX_PACKAGE_NAME}"
}

function tmux::sync {
    rsync -avzh --progress "${TMUX_PATH}/data/conf/" "${HOME}/"
    rsync -avzh --progress "${TMUX_PATH}/data/sync/" "${HOME_CONFIG_PATH}/"
}

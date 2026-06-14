# shellcheck shell=bash

function hyprland::install {
    hyprland::internal::hyprland::install
}

function hyprland::post_install {
    message_info "Post Install ${HYPRLAND_PACKAGE_NAME}"
    hyprland::sync
    message_success "Success Install ${HYPRLAND_PACKAGE_NAME}"
}

function hyprland::sync {
    rsync -avzh --progress "${HYPRLAND_PATH}/data/" "${HYPRLAND_CONFIG_PATH}/"
}
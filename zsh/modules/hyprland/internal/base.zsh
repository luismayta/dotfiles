# shellcheck shell=bash
function hyprland::internal::hyprland::install {
    message_info "Installing ${HYPRLAND_PACKAGE_NAME}"
    core::install hyprland
    core::install hypridle
    core::install hyprlock
    core::install hyprpaper
    core::install waybar
    core::install dunst
    message_success "Installed ${HYPRLAND_PACKAGE_NAME}"
    hyprland::post_install
}

function hyprland::internal::classes {
    hyprctl clients -j 2>/dev/null | jq -r '.[] | .class' | sort -u
}
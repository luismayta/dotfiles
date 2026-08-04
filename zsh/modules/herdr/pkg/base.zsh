# shellcheck shell=bash
function herdr::install {
  herdr::internal::install
}

function herdr::update {
    herdr::internal::update
}

function herdr::sync {
  herdr::internal::config::sync
}

function herdr::post_install {
  message_info "Post Install ${ZSH_HERDR_PACKAGE_NAME}"
  herdr::sync
  message_success "Success Install ${ZSH_HERDR_PACKAGE_NAME}"
}

# ──────────────────────────────────────────────
# Plugin wrappers
# ──────────────────────────────────────────────

function herdr::plugin::install {
    herdr::internal::plugin::install "$@"
}

function herdr::plugin::list {
    herdr::internal::plugin::list
}

function herdr::plugin::update {
    herdr::internal::plugin::update "$@"
}

function herdr::plugin::update::all {
    herdr::internal::plugin::update::all
}

function herdr::plugin::uninstall {
    herdr::internal::plugin::uninstall "$@"
}
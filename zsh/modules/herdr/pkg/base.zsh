# shellcheck shell=bash
function hrd::install {
  hrd::internal::install
}

function hrd::update {
  hrd::internal::update
}

function hrd::sync {
  hrd::internal::config::sync
}

function hrd::post_install {
  message_info "Post Install ${ZSH_HERDR_PACKAGE_NAME}"
  hrd::sync
  message_success "Success Install ${ZSH_HERDR_PACKAGE_NAME}"
}

# ──────────────────────────────────────────────
# Plugin wrappers
# ──────────────────────────────────────────────

function hrd::plugin::install {
  hrd::internal::plugin::install "$@"
}

function hrd::plugin::list {
  hrd::internal::plugin::list
}

function hrd::plugin::update {
  hrd::internal::plugin::update "$@"
}

function hrd::plugin::update::all {
  hrd::internal::plugin::update::all
}

function hrd::plugin::uninstall {
  hrd::internal::plugin::uninstall "$@"
}

# ──────────────────────────────────────────────
# Espresso wrappers (macOS-only)
# ──────────────────────────────────────────────

function hrd::espresso::install {
  hrd::internal::deps::install::espresso
}

function hrd::espresso::daemon::install {
  hrd::internal::espresso::daemon::install
}
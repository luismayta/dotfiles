# shellcheck shell=bash
# nix-darwin public API

nix::darwin::install() {
  nix::darwin::internal::ensure
}

nix::darwin::rebuild() {
  nix::darwin::internal::rebuild
}

nix::darwin::update() {
  nix::darwin::internal::update
}

nix::darwin::status() {
  nix::darwin::internal::status
}

nix::darwin::daemon::status() {
  nix::internal::daemon::status
}

nix::darwin::daemon::load() {
  nix::internal::daemon::load
}

nix::darwin::daemon::restart() {
  nix::internal::daemon::restart
}

nix::darwin::post_install() {
  message_info "Post Install ${ZSH_NIX_DARWIN_PACKAGE_NAME}"
  message_success "nix-darwin configured."
}

# shellcheck shell=bash
# nix-darwin setup orchestrator

nix::darwin::setup() {
  message_info "Setting up ${ZSH_NIX_DARWIN_PACKAGE_NAME}..."

  if ! command -v nix &>/dev/null; then
    nix::darwin::install
  else
    message_info "nix is already installed."
  fi

  nix::darwin::status
  message_success "${ZSH_NIX_DARWIN_PACKAGE_NAME} setup complete."
}

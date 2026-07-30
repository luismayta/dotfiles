# shellcheck shell=bash
# Public API: Nix module

function nix::install {
  core::nix::ensure
}

function nix::channel::set {
  local channel="${1:-nixpkgs}"
  nix-channel --add "https://nixos.org/channels/${channel}" "${channel}"
  nix-channel --update
}

function nix::channel::list {
  nix-channel --list
}

function nix::gc {
  message_info "This will remove ALL unused nix store items (garbage collect)"
  message_warning "Are you sure? (y/N): "
  read -r confirmation
  if [[ "${confirmation}" =~ ^[Yy]$ ]]; then
    nix-collect-garbage -d
    message_success "Garbage collection completed"
  else
    message_info "Garbage collection cancelled"
  fi
}

function nix::build {
  nix develop --command true
}

function nix::develop {
  nix develop --command zsh
}

function nix::sync {
    nix::internal::config::sync
}
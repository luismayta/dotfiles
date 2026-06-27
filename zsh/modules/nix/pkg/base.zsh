# shellcheck shell=bash
# Public API: Nix module

nix::install() {
  core::nix::ensure
}

nix::channel::set() {
  local channel="${1:-nixpkgs}"
  nix-channel --add "https://nixos.org/channels/${channel}" "${channel}"
  nix-channel --update
}

nix::channel::list() {
  nix-channel --list
}

nix::gc() {
  nix-collect-garbage -d
}

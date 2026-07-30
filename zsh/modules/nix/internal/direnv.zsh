# shellcheck shell=bash
# nix-direnv — global direnv plugin for cached flake evaluation

nix::internal::direnv::setup() {
    # Install nix-direnv via nix profile if not already present
    if ! nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing nix-direnv"
        nix profile install nixpkgs#nix-direnv
        message_success "Installed nix-direnv"
    fi
}

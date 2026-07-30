# shellcheck shell=bash
# macOS-specific nix-darwin helpers
#
# Provides functions to manage nix-darwin system configuration:
# rebuild, update, status, and bootstrap hint.

# Detect nix-darwin availability
if command -v darwin-rebuild &>/dev/null; then
  export ZSH_NIX_DARWIN_AVAILABLE=true
else
  export ZSH_NIX_DARWIN_AVAILABLE=false
fi

# nix::darwin::rebuild — rebuild nix-darwin system configuration
nix::darwin::rebuild() {
  if [[ "$ZSH_NIX_DARWIN_AVAILABLE" != "true" ]]; then
    echo "nix-darwin: not detected. Cannot rebuild." >&2
    return 1
  fi
  sudo darwin-rebuild switch --flake "${DOTFILES_DIR}/nix/darwin#$(hostname -s)"
}

# nix::darwin::update — update nix-darwin inputs and rebuild
nix::darwin::update() {
  if [[ "$ZSH_NIX_DARWIN_AVAILABLE" != "true" ]]; then
    echo "nix-darwin: not detected. Cannot update." >&2
    return 1
  fi
  nix flake update && nix::darwin::rebuild
}

# nix::darwin::status — show nix-darwin status
nix::darwin::status() {
  if [[ "$ZSH_NIX_DARWIN_AVAILABLE" == "true" ]]; then
    echo "nix-darwin: active"
    echo "profile: /nix/var/nix/profiles/system"
    echo "hostname: $(scutil --get ComputerName 2>/dev/null || echo 'unknown')"
  else
    echo "nix-darwin: not detected"
  fi
}

# Bootstrap hint for macOS without nix-darwin
if [[ "$ZSH_NIX_DARWIN_AVAILABLE" != "true" ]]; then
  echo "nix-darwin: not detected. To bootstrap, run:"
  echo "  nix run nix-darwin -- switch --flake ${DOTFILES_DIR}/nix/darwin#$(hostname -s)"
fi

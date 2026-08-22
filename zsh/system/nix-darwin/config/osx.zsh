# shellcheck shell=bash
# macOS-specific nix-darwin config — env vars only

if command -v darwin-rebuild &>/dev/null; then
  export ZSH_NIX_DARWIN_AVAILABLE=true
else
  export ZSH_NIX_DARWIN_AVAILABLE=false
fi

# Add nix paths if they exist (independent of /etc/zshrc sourcing)
for p in /nix/var/nix/profiles/default/bin "${HOME}/.nix-profile/bin"; do
  [[ -d "${p}" ]] && [[ ":${PATH}:" != *":${p}:"* ]] && export PATH="${p}:${PATH}"
done

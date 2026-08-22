# shellcheck shell=bash
# macOS-specific smolvm config
# NOTE: upstream publishes only darwin-arm64 (Apple Silicon). Intel Macs are
# not supported by the release assets.

# Platform asset identifier (used in archive filename and URL)
export ZSH_SMOLVM_ASSET="darwin-arm64"
# SHA256 of the official smolvm-1.3.2-darwin-arm64.tar.gz asset (from the release checksums.sha256)
export ZSH_SMOLVM_SHA256="a67dd6fae008ed4a198aab4d6814e82d196a81d08dc671c811f38c3f81e4b8ce"
# Download URL for the darwin-arm64 release asset
export ZSH_SMOLVM_INSTALL_URL="https://github.com/smol-machines/smolvm/releases/download/v1.3.2/smolvm-1.3.2-darwin-arm64.tar.gz"

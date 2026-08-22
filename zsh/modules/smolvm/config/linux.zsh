# shellcheck shell=bash
# Linux-specific smolvm config

# Platform asset identifier (used in archive filename and URL)
export ZSH_SMOLVM_ASSET="linux-x86_64"
# SHA256 of the official smolvm-1.3.2-linux-x86_64.tar.gz asset (from the release checksums.sha256)
export ZSH_SMOLVM_SHA256="251f357e2eb0e498de08ca75325e6cf5c96380ecd4adbe7da14a517e8ea7cae0"
# Download URL for the linux-x86_64 release asset
export ZSH_SMOLVM_INSTALL_URL="https://github.com/smol-machines/smolvm/releases/download/v1.3.2/smolvm-1.3.2-linux-x86_64.tar.gz"

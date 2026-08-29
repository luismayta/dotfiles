# Bitwarden CLI Binary Installation

## Purpose

Replace vulnerable yarn-based Bitwarden CLI installation with secure native binary download in the existing `zsh/modules/bitwarden/` module.

## Requirements

### Config Layer

- MUST export `BITWARDEN_INSTALL_URL` with official download URL
- MUST export `BITWARDEN_BIN_DIR` for binary installation directory
- MUST export `BITWARDEN_BIN_PATH` for the binary executable path
- All variables MUST use `BITWARDEN_` prefix (existing convention)

### Internal Layer

- MUST replace `yarn global add @bitwarden/cli` with binary download
- MUST implement `bitwarden::internal::bitwarden::install` with architecture detection (arm64/amd64)
- MUST implement `bitwarden::internal::bitwarden::upgrade` for version updates
- MUST detect OS via `${OSTYPE}` (darwin/linux)
- MUST use `message_info`/`message_success`/`message_error` for user feedback

### Registration

- MUST update `internal/main.zsh` to use `bitwarden::internal::bitwarden::install` instead of `core::install bw`

### Cross-Platform

- MUST support macOS (darwin) with arm64 and x86_64 architectures
- MUST support Linux with arm64 and x86_64 architectures

### Security

- MUST NOT depend on npm or yarn package managers
- MUST download from official Bitwarden distribution URLs
- MUST verify binary exists after installation

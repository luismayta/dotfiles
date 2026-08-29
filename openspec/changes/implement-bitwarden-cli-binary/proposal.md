## Why

The Bitwarden CLI npm package (`@bitwarden/cli`) was hijacked in version 2026.4.0 with a malicious payload that uses Bun to steal credentials (JFrog Research - TeamPCP Campaign). The existing bitwarden module uses `yarn global add @bitwarden/cli` in `internal/base.zsh`, which is vulnerable. We need to replace this with native binary download.

## What Changes

- Replace yarn-based installation in `zsh/modules/bitwarden/internal/base.zsh` with binary download from official Bitwarden URL
- Add binary path variables to `zsh/modules/bitwarden/config/base.zsh`
- Add upgrade function for version management
- Update `internal/main.zsh` to use new binary download function

## Capabilities

### New Capabilities

- `bitwarden-cli-binary`: Secure binary download installation for Bitwarden CLI, replacing vulnerable npm/yarn dependency

### Modified Capabilities

(none)

## Impact

- **Files modified**: `config/base.zsh`, `internal/base.zsh`, `internal/main.zsh` in `zsh/modules/bitwarden/`
- **Security**: Eliminates npm package dependency, uses official binary distribution
- **Compatibility**: Maintains existing fzf/clipboard functionality

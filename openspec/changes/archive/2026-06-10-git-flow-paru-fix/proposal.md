## Why

On Linux (CachyOS/Arch), `core::ensure git-flow` runs `paru -S --noconfirm git-flow`, but no package named `git-flow` exists in AUR. The correct package is `gitflow-avh` (which installs the `git-flow` binary). This causes the git module to fail on Linux when auto-installing dependencies.

## What Changes

- Add `export GIT_FLOW_PACKAGE_NAME=gitflow-avh` in `zsh/modules/git/config/linux.zsh`
- Change `core::ensure git-flow` to `core::ensure "${GIT_FLOW_PACKAGE_NAME:-git-flow}"` in `zsh/modules/git/internal/main.zsh`

## Capabilities

### New Capabilities
- `git-flow-install-linux`: Override the git-flow package name for Linux (paru/AUR) so it resolves to `gitflow-avh` instead of the non-existent `git-flow`.

### Modified Capabilities
- *(none)*

## Impact

- `zsh/modules/git/config/linux.zsh` — new export for the AUR package name
- `zsh/modules/git/internal/main.zsh` — use `${GIT_FLOW_PACKAGE_NAME:-git-flow}` instead of hardcoded `git-flow`
- macOS (brew) remains unaffected, defaulting to `git-flow` as before

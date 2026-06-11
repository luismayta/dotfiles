## Why

The `zsh-rvm` module currently lives as an external repository (`hadenlabs/zsh-rvm`) maintained separately from the dotfiles monorepo. Migrating it into `zsh/modules/rvm/` aligns with the ongoing consolidation of all zsh modules into the dotfiles repo — simplifying maintenance, ensuring consistent patterns (idempotency guards, `core::ensure`, `shellcheck`), and eliminating dependency on an external plugin.

## What Changes

- **New `zsh/modules/rvm/` directory** created under dotfiles, following the established module pattern (plugin.zsh, config/, internal/, pkg/)
- Copy all meaningful source files from `hadenlabs/zsh-rvm` into the new module structure
- Adapt to dotfiles conventions:
  - `zsh-rvm.zsh` → `plugin.zsh` with idempotency guard (`__ZSH_RVM_LOADED`)
  - Entry point path variable `ZSH_RVM_PATH` → derived from `plugin.zsh` location
  - Shebang `#!/usr/bin/env ksh` → `# shellcheck shell=bash`
  - Module auto-install via `core::ensure` instead of inline checks
  - OS-dispatch functions refactored to flat sourcing for consistency
- Register the module in the dotfiles module loader (zshrc)

## Capabilities

### New Capabilities
- `rvm-module`: RVM (Ruby Version Manager) module for dotfiles — installation, version management, gem package provisioning, and macOS OpenSSL@3 integration

### Modified Capabilities
- (none — new module, no existing specs affected)

## Impact

- **New directory**: `zsh/modules/rvm/` (8-10 files, ~240 lines)
- **External repo**: `hadenlabs/zsh-rvm` becomes secondary; future development happens in dotfiles
- **Dependencies**: No new external dependencies (rvm/curl/gpg were already required)
- **Module loader**: Minor update to zshrc or module loader config to register `rvm`

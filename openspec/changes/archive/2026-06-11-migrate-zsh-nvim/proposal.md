## Why

Consolidate the external `hadenlabs/zsh-nvim` module into the dotfiles monorepo under `zsh/modules/nvim/`, following the same pattern established by `brew`, `git`, `rvm`, and other migrated modules. This eliminates an external dependency, enables unified versioning, and ensures all zsh module configuration lives in one place.

## What Changes

- Migrate `hadenlabs/zsh-nvim` source code into `zsh/modules/nvim/` with the monorepo's standard 3-layer convention (`config/` → `internal/` → `pkg/`)
- Replace factory-function initialization with flat OS dispatch sourcing (matching brew/rvm pattern)
- Replace `#!/usr/bin/env ksh` shebangs with `# shellcheck shell=bash`
- Remove external plugin reference from `zsh/zsh_plugins.txt` if present
- Preserve existing capabilities: auto-install neovim, clone/upgrade nvimrc config, clean caches, `vim` alias, `editnvim` helper

## Capabilities

### New Capabilities
- `nvim-module`: Neovim module providing auto-installation, configuration management (nvimrc git repo clone/upgrade), cache cleanup, `vim` command alias, and `editnvim` helper function

### Modified Capabilities
*(none — no existing specs are being changed)*

## Impact

- `zsh/modules/nvim/` — new directory with config, internal, and pkg layers (14 files)
- `zsh/zshrc` — no change needed (module auto-discovery via `modules/*/plugin.zsh`)
- `zsh/zsh_plugins.txt` — remove `hadenlabs/zsh-nvim` if present
- Source repo `hadenlabs/zsh-nvim` — all future development happens in dotfiles; external repo becomes read-only reference
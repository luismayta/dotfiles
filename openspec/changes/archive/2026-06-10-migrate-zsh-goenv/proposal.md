## Why

The `hadenlabs/zsh-goenv` plugin is an external dependency currently loaded via antidote in `zsh/zsh_plugins.txt`. Migrating it into the monorepo `zsh/modules/` structure eliminates an external dependency, aligns with the ongoing initiative to consolidate all zsh plugins, and allows the module to follow the canonical three-layer pattern (config → internal → pkg) with OS dispatch, idempotency guards, and auto-install logic already established by core, brew, rust, and fnm modules.

## What Changes

- Create `zsh/modules/goenv/` with a full three-layer architecture (config/, internal/, pkg/) following the core module pattern
- Port all `goenv::*` functions preserving their exact namespaces and behavior (18 functions total)
- Remove `hadenlabs/zsh-goenv` from `zsh/zsh_plugins.txt`
- Add idempotency guard (`__ZSH_GOENV_LOADED`) to prevent double-sourcing
- Port all config variables (`GOENV_*`, `GOBREW_*`, `GO111MODULES`, `ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH`, `GOENV_VERSIONS`, `GOENV_VERSION_GLOBAL`, `GOENV_INSTALL_PACKAGES`)
- Rename `ZSH_GOENV_PATH` (module root) to `GOENV_PATH` to avoid collision with any user-facing env var of the same name

## Capabilities

### New Capabilities
- `goenv-module`: Port of `hadenlabs/zsh-goenv` into `zsh/modules/goenv/` with Go version management via gobrew, PATH setup, and Go package management

### Modified Capabilities
- *(none — no existing specs are changing)*

## Impact

- **New files**: `zsh/modules/goenv/` (17 files: plugin.zsh + 4 config + 6 internal + 6 pkg following the core module pattern)
- **Modified files**: `zsh/zsh_plugins.txt` (remove `hadenlabs/zsh-goenv`)
- **Dependencies**: Requires `zsh/modules/core/` for `core::exists`, `core::install`, `message_*` functions (already present in all modules); uses `gobrew` for Go version management and `go install` for packages
- **No breaking changes**: All `goenv::*` public API functions are preserved identically
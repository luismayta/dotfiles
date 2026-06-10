## Why

The `hadenlabs/zsh-fnm` external plugin is the next candidate in the monorepo migration initiative. FNM (Fast Node Manager) is a core Node.js toolchain dependency used across projects. Moving it into `zsh/modules/fnm/` standardizes on the multi-file architecture (`config/`, `internal/`, `pkg/`) already established by `core`, `brew`, and `rust`, and removes an antidote-managed dependency from `zsh/zsh_plugins.txt`.

## What Changes

- New `zsh/modules/fnm/` module with three-layer architecture: `config/`, `internal/`, `pkg/` and OS dispatch (macOS/Linux)
- Source all `fnm::*` functions preserving namespaces: `fnm::internal::fnm::install`, `fnm::internal::fnm::load`, `fnm::internal::packages::install`, `fnm::internal::version::all::install`, `fnm::internal::version::global::install`, `fnm::internal::fnm::upgrade`, and public wrappers (`fnm::install`, `fnm::load`, `fnm::post_install`, `fnm::upgrade`, `fnm::package::all::install`, `fnm::install::versions`, `fnm::install::version::global`)
- Replace factory-function dispatching (`fnm::config::main::factory`, etc.) with direct sourcing matching the monorepo pattern
- Omit the extraneous `core/` layer from the source (it only contained empty stubs — the monorepo already has its own core module)
- Relocate auto-install side-effects from `internal/main.zsh` to `pkg/base.zsh` per monorepo convention
- Remove `hadenlabs/zsh-fnm` from `zsh/zsh_plugins.txt`

## Capabilities

### New Capabilities

- `fnm-module`: Fast Node Manager (fnm) installation, version management, PATH setup, and npm package management via the monorepo module system

### Modified Capabilities

*None.*

## Impact

- **Affected files**: `zsh/modules/fnm/` (new directory, ~15 files), `zsh/zsh_plugins.txt` (remove one line)
- **API preserved**: All `fnm::*` function names and namespaces remain identical — zero breakage for any code calling these functions
- **Dependencies**: Relies on `core::exists` and `core::install` from `zsh/modules/core/` (already loaded before `fnm` alphabetically in the module loop)
- **Risk**: Low — identical logic, same function names, same env vars, no breaking changes
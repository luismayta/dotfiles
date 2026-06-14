## Why

The dotfiles project manages shell configuration and installed tools through modular zsh modules in `zsh/modules/`. Currently there is no dedicated module for managing desktop application installation — the functionality exists in a separate repository (`zsh-apps`) with redundant infrastructure (its own `core/` layer, factory pattern) that doesn't follow the dotfiles' KISS three-layer architecture. Consolidating this into `zsh/modules/apps/` eliminates duplication, leverages shared `zsh/core/`, and brings app management under the same consistency guarantees as every other module.

Additionally, the existing `zsh-apps` uses `nativefiel`/`nativefier` for wrapping web apps as desktop applications. The replacement is `pake` (Rust + Tauri), which produces ~20× smaller binaries and is actively maintained.

## What Changes

- **New module**: `zsh/modules/apps/` following the three-layer architecture from `docs/guides/create-module.md`
- **Migration**: Port categorized app lists and install logic from `/home/lucho/Projects/src/github.com/luismayta/zsh-apps`
- **Core consolidation**: Drop the redundant `core/` layer — use shared `zsh/core/` (`core::install`, `core::exists`, `message_*`) instead
- **Replace nativefier with pake**: Use `pake` CLI for wrapping web apps as desktop applications
- **Update `.goji.json`**: Add `apps` scope
- **Register the module**: Wire into the module loader so it auto-loads

## Capabilities

### New Capabilities
- `apps-install`: Categorized desktop application installation with auto-install on shell start, organized by category (IDE, Communication, Knowledge, DevOps, Database, Browser, Android, Mobile, VPN, Project Management)

### Modified Capabilities
- *(none — no existing specs are changing)*

## Impact

- **New directory**: `zsh/modules/apps/` with 16 files (scaffold + implementation)
- **Module loader**: Update to source `zsh/modules/apps/plugin.zsh`
- **Scope registry**: Add `apps` to `.goji.json` scopes
- **Removed**: Dependency on standalone `zsh-apps` repo (retained for reference, no longer loaded)

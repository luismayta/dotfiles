## Why

Functions in the `zsh/core/` module don't follow the established naming convention (`core::*::*`), creating inconsistency and confusion. This makes it unclear which functions are part of the core module's public API versus internal implementation. The inconsistency affects maintainability and developer experience when working with the dotfiles codebase.

## What Changes

- **BREAKING**: Rename `path::prepend` → `core::path::prepend` in `internal/path.zsh`
- **BREAKING**: Rename `path::append` → `core::path::append` in `internal/path.zsh`
- **BREAKING**: Rename `path::clean` → `core::path::clean` in `internal/path.zsh`
- **BREAKING**: Rename `backup` → `core::internal::backup` in `internal/backup.zsh` (legacy function)
- **BREAKING**: Rename `reload` → `core::reload` in `internal/reload.zsh`
- **BREAKING**: Rename `editrc` → `core::editrc` in `internal/editor.zsh`
- **BREAKING**: Rename `editprivaterc` → `core::editprivaterc` in `internal/editor.zsh`
- **BREAKING**: Rename `editcustomrc` → `core::editcustomrc` in `internal/editor.zsh`
- Update all callers of renamed functions throughout the codebase
- Remove duplicate `reload` definition in `internal/osx.zsh` (consolidate with main implementation)
- Create `jasper::*` wrapper commands in `bin/` that call the renamed `core::*` functions

## Capabilities

### New Capabilities

- `core-naming-convention`: Establishes and enforces the `core::*::*` naming pattern for all functions in the zsh/core module, ensuring consistency with the module's namespace

### Modified Capabilities

<!-- Leave empty if no requirement changes -->

## Impact

- **Affected files**: `internal/path.zsh`, `internal/backup.zsh`, `internal/reload.zsh`, `internal/editor.zsh`, `internal/osx.zsh`
- **Callers to update**: Any scripts or functions that call the renamed functions (e.g., `path::prepend` in various module files)
- **Breaking changes**: All renamed functions will break existing callers until updated
- **No API changes**: Function signatures and behavior remain identical, only names change

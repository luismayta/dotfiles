## Why

The `github` module was extracted from `devops` but does not follow the module architecture defined in `docs/guides/create-module.md`. It's missing `main.zsh` files per layer, OS-specific placeholders, the `pkg/helper.zsh` orchestrator, and uses non-standard file naming (`gh.zsh` instead of `base.zsh`). Additionally, gh extension management is hardcoded instead of following the krew-style config-driven pattern used by `devops/kubectl`.

## What Changes

- **Restructure files**: Rename `config/gh.zsh` → `config/base.zsh`, `internal/gh.zsh` → `internal/base.zsh`, `pkg/gh.zsh` → `pkg/base.zsh`
- **Add `main.zsh` per layer**: `config/main.zsh`, `internal/main.zsh`, `pkg/main.zsh` with OS dispatch
- **Add OS placeholders**: `config/osx.zsh`, `config/linux.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`
- **Add `pkg/helper.zsh`**: `github::setup` orchestrator function
- **Add `pkg/alias.zsh`**: Move `ghd` alias and `editghdash` function here
- **Fix `plugin.zsh`**: Use `${0:A:h}` path, `[[ -n "${__ZSH_GITHUB_LOADED:-}" ]] && return` guard, add `message_info "Loading module: github"`, move enabled toggle after config sourcing
- **Add `ZSH_GITHUB_ENABLED` toggle**: In `config/base.zsh` (currently missing)
- **Add extension pattern**: `ZSH_GITHUB_EXTENSIONS=(dlvhdr/gh-dash)` array in config, `github::internal::extension::install` / `extensions::install` functions in internal, public wrappers in pkg
- **Fix `core::exists` usage**: Replace `gh extension list | grep` with `core::exists` pattern

## Capabilities

### New Capabilities

- `github-module-scaffold`: Full 3-layer module structure with `main.zsh` per layer, OS placeholders, guard, and path conventions per `create-module.md`
- `github-extension-management`: Config-driven gh extension install/upgrade pattern (krew-style) with `ZSH_GITHUB_EXTENSIONS` array

### Modified Capabilities

_(none — this is the first spec for the github module)_

## Impact

- **Files modified**: `zsh/modules/github/plugin.zsh`, `zsh/modules/github/config/gh.zsh` (renamed), `zsh/modules/github/internal/gh.zsh` (renamed), `zsh/modules/github/pkg/gh.zsh` (renamed)
- **Files created**: 12 new files (3 `main.zsh` + 6 OS stubs + `pkg/helper.zsh` + `pkg/alias.zsh`)
- **Dependencies**: None — all changes are within the github module

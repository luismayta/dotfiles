## Context

The `devops` zsh module currently bundles GitHub CLI (`gh`) and `gh-dash` alongside infrastructure tools (kubectl, helm, tfenv, etc.). The GH-specific code lives in dedicated files (`config/gh.zsh`, `internal/gh.zsh`, `pkg/gh.zsh`, `data/gh/`) but uses `DEVOPS_GH_*` variable prefixes and `devops::gh::*` function namespaces.

The project has an established module architecture (`docs/guides/create-module.md`) with:
- 3-layer structure: config → internal → pkg
- `plugin.zsh` entry point with guard variables
- `ZSH_<MODULE>_` naming convention
- OS-specific file loading
- Module-level enable/disable toggles

## Goals / Non-Goals

**Goals:**
- Extract GitHub CLI into a standalone `github` module following the module creation guide
- Migrate all `DEVOPS_GH_*` variables to `ZSH_GITHUB_*` convention
- Migrate all `devops::gh::*` functions to `github::*` / `github::internal::*` namespace
- Maintain all existing functionality (completions, gh-dash install, aliases)
- Remove GH references from the devops module cleanly

**Non-Goals:**
- Adding new GitHub CLI features beyond what exists
- Changing the gh-dash configuration format
- Refactoring other devops tools
- Modifying the module loading system

## Decisions

### Decision 1: Follow the Module Creation Guide exactly

**Choice**: Use the standard 3-layer architecture with `plugin.zsh` entry point

**Rationale**:
- Consistent with all other modules in the project
- Clear enable/disable mechanism via `ZSH_GITHUB_ENABLED`
- Guard variable `__ZSH_GITHUB_LOADED` prevents double-loading
- Standard `ZSH_GITHUB_PATH` and `ZSH_GITHUB_DATA_PATH` variables

**Alternatives considered**:
- Keep inline loading in devops: Rejected — defeats the purpose of extraction
- Create a minimal module without plugin.zsh: Rejected — breaks convention

### Decision 2: Variable Naming Migration

**Choice**: Rename all `DEVOPS_GH_*` to `ZSH_GITHUB_*`

**Mapping**:
- `DEVOPS_GH_PACKAGE_NAME` → `ZSH_GITHUB_PACKAGE_NAME` (value: `gh`)
- `DEVOPS_GH_CONF_PATH` → `ZSH_GITHUB_CONF_PATH` (value: `~/.config/gh`)
- `DEVOPS_GH_DASH_CONF_PATH` → `ZSH_GITHUB_DASH_CONF_PATH` (value: `~/.config/gh-dash`)
- `DEVOPS_GH_DATA_PATH` → `ZSH_GITHUB_DATA_PATH` (value: `${ZSH_GITHUB_PATH}/data/gh`)

**Rationale**: Follows the `ZSH_<MODULE>_` convention documented in the creation guide.

### Decision 3: Function Namespace Migration

**Choice**: Rename functions from `devops::gh::*` to `github::*`

**Mapping**:
- `devops::gh::internal::main::factory` → `github::internal::main::factory`
- `devops::gh::internal::install_completions` → `github::internal::install_completions`
- `devops::gh::internal::install_dash` → `github::internal::install_dash`
- `devops::gh::internal::load` → `github::internal::load`
- `devops::gh::install` → `github::install`
- `devops::gh::upgrade` → `github::upgrade`
- `devops::gh::post_install` → `github::post_install`
- `devops::gh::sync` → `github::sync`

**Rationale**: Functions should match the module name without the `devops::` prefix.

### Decision 4: Aliases remain unchanged

**Choice**: Keep `ghd="gh dash"` alias and `editghdash` function as-is

**Rationale**: These are user-facing commands that don't follow the internal namespace convention. They should remain stable.

### Decision 5: Data directory structure

**Choice**: Move `data/gh/` to `github/data/gh/` preserving the `config.yaml` file

**Rationale**: The gh-dash configuration is module-specific data and belongs with the module.

## Risks / Trade-offs

### Risk 1: Breaking existing workflows
**Risk**: Users with `DEVOPS_GH_*` variables set in their shell will break

**Mitigation**: The variables are internal to the module loading system and not typically set by users directly. The migration is clean because the old devops module will no longer source GH config.

### Risk 2: Function name collisions
**Risk**: If any external script calls `devops::gh::*` functions, they will break

**Mitigation**: The functions are internal to the zsh module system and not part of a public API. External scripts should use the `gh` CLI directly.

### Risk 3: Module loading order
**Risk**: If github module loads before devops, some devops functions might be unavailable

**Mitigation**: The github module is self-contained and doesn't depend on devops functions. The `core::ensure` and `core::upgrade` functions are from the core library, not devops.

## Migration Plan

1. Create the new `github` module structure with all files
2. Update devops module to remove GH references
3. Test that both modules load correctly
4. Verify `gh` and `gh-dash` still work
5. Remove old GH files from devops (done in step 1 creation)

**Rollback**: If issues occur, restore the GH files to devops and remove the github module.

## Open Questions

- Should the module be named `github` or `gh`? (Decision: `github` — matches the service name, not the CLI binary)
- Should `editghdash` be renamed to follow a convention? (Decision: No — it's a user-facing convenience function)

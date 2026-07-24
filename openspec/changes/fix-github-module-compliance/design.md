## Context

The `github` module was extracted from `devops` via the `extract-github-module` change (HAD-89). The extraction was functionally correct — all `DEVOPS_GH_*` variables and `devops::gh::*` functions were migrated to `ZSH_GITHUB_*` and `github::*`. However, the module does not follow the architecture defined in `docs/guides/create-module.md`.

The `devops` module is the canonical reference for module structure. It has:
- `config/main.zsh` → OS dispatch for config
- `internal/main.zsh` → OS dispatch + layer source
- `pkg/main.zsh` → OS dispatch + layer source
- `config/base.zsh` with `ZSH_DEVOPS_ENABLED` toggle
- `internal/base.zsh` with core install functions
- `pkg/base.zsh` with `devops::install` orchestrator
- `pkg/helper.zsh` with `devops::setup`
- `pkg/alias.zsh` with aliases
- OS stubs: `config/osx.zsh`, `config/linux.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`

The `github` module is missing most of this.

## Goals / Non-Goals

**Goals:**
- Full compliance with `create-module.md` scaffold
- Config-driven gh extension management (krew-style pattern from `devops/kubectl`)
- Standard guard, path, and toggle conventions
- Separation of aliases into `pkg/alias.zsh`

**Non-Goals:**
- Adding new gh functionality beyond what exists
- Changing the `ZSH_GITHUB_*` variable names (already correct)
- Modifying `data/gh/config.yaml` structure

## Decisions

### 1. File naming: `gh.zsh` → `base.zsh`

**Decision**: Rename all `gh.zsh` files to `base.zsh` in config, internal, and pkg layers.

**Rationale**: The convention is `base.zsh` for the primary domain file. `gh.zsh` works as a sub-topic file (like `kubectl.zsh` in devops) but `base.zsh` is the canonical name for the main functions of a module.

**Alternative considered**: Keep `gh.zsh` as the main file. Rejected because it breaks the convention and creates confusion about whether `base.zsh` should also exist.

### 2. Extension pattern: krew-style config array

**Decision**: Add `ZSH_GITHUB_EXTENSIONS=(dlvhdr/gh-dash)` in config, with install/load functions following the devops/kubectl krew pattern.

**Rationale**: The devops module already has this pattern for kubectl plugins. It's proven, config-driven, and easy to extend.

**Alternative considered**: Keep hardcoded `dlvhdr/gh-dash` in internal. Rejected because it's not extensible and breaks the config-driven philosophy.

### 3. Guard pattern: `${0:A:h}` + loaded check

**Decision**: Use `${0:A:h}` for path resolution and `[[ -n "${__ZSH_GITHUB_LOADED:-}" ]] && return` for guard.

**Rationale**: This is the standard from `create-module.md`. The current guard `[[ "${ZSH_GITHUB_LOADED:-}" == "true" ]] && return` is functionally equivalent but non-standard.

### 4. OS stubs: placeholders only

**Decision**: Create OS-specific files as minimal placeholders (same as devops).

**Rationale**: The github module has no OS-specific logic today, but the structure must be in place for future use. Placeholders are 2-line files that follow the devops pattern.

## Risks / Trade-offs

- **File rename churn**: Renaming `gh.zsh` → `base.zsh` creates git diff noise but is necessary for convention compliance
- **Extension pattern overhead**: Adding the krew-style pattern adds 4+ files but is required for extensibility
- **No functional changes**: This is purely structural — no new user-facing behavior

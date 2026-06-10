## Context

The dotfiles project currently loads ZSH modules from `zsh/modules/` — each module is a subdirectory with a `plugin.zsh` entry point, plus `config/`, `internal/`, and `pkg/` subdirectories for platform-specific logic. The reference implementation is `zsh/modules/core/`, which follows this exact pattern:

```
modules/core/
├── plugin.zsh          # Entry point: idempotency guard + chained sourcing
├── config/
│   ├── main.zsh        # Sources base.zsh + OS switch (darwin/linux)
│   ├── base.zsh        # Base env vars
│   ├── osx.zsh         # macOS overrides
│   └── linux.zsh       # Linux overrides
├── internal/
│   ├── main.zsh        # Sources internal files + OS switch
│   ├── base.zsh        # Internal utility functions
│   ├── osx.zsh
│   ├── linux.zsh
│   ├── git.zsh
│   └── backup.zsh
└── pkg/
    ├── main.zsh        # Sources pkg files + OS switch
    ├── base.zsh        # Public API wrappers
    ├── osx.zsh
    ├── linux.zsh
    ├── alias.zsh
    ├── docker.zsh
    └── helper/
        └── main.zsh
```

Four additional modules (`zsh-aliases`, `zsh-clean`, `zsh-pazi`, `zsh-devops`) live in separate repositories with a similar but not identical structure. Each has the same `config/`, `internal/`, `pkg/` layout plus a `core/` directory, but uses factory-function wrappers and a root entry point named after the repo (e.g., `zsh-aliases.zsh`) instead of `plugin.zsh`.

The migration copies these external modules into the dotfiles tree, adapting them to the existing `core`-style convention so all ZSH configuration is centralized and consistent.

## Goals / Non-Goals

**Goals:**
- Copy all files from the 4 external repos into `zsh/modules/<name>/` directories
- Adapt each module to the existing `core`-style convention: `plugin.zsh` with idempotency guard, direct sourcing (no factory functions), `<NAME>_PATH` variable
- Merge `core/` directory contents from external repos into `internal/` (since existing modules have no `core/` dir)
- Keep external repos untouched (they remain in place for reference)

**Non-Goals:**
- Not modifying existing modules (brew, core, fnm, etc.)
- Not consolidating or deduplicating code across the 4 new modules
- Not changing the module loading mechanism in `mod/main.zsh`
- Not deleting the source repositories

## Decisions

1. **Directory naming**: Use `aliases`, `clean`, `pazi`, `devops` (short names matching module purpose) rather than the full repo names (`zsh-aliases`, etc.), consistent with existing module naming (`brew`, `core`, `fnm`, `git`, etc.)

2. **plugin.zsh convention**: Each module gets a `plugin.zsh` following the exact pattern from `zsh/modules/core/plugin.zsh`:
   - Idempotency guard: `[[ -n "${__ZSH_<NAME>_LOADED:-}" ]] && return`
   - Module root: `<NAME>_PATH="$(dirname "${0}")"`
   - Chain sourcing: `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`
   - No factory function wrappers — direct sourcing like `core`

3. **Factory functions → direct sourcing**: External repos wrap each `main.zsh` in a factory function (e.g., `aliases::config::main::factory`). Migrated modules will remove these wrappers and source files directly, matching the `core` pattern.

4. **Path variable rename**: External repos use `ZSH_<NAME>_PATH` (e.g., `ZSH_ALIASES_PATH`). Migrated modules use `<NAME>_PATH` (e.g., `ALIASES_PATH`), matching the `CORE_PATH` convention.

5. **Core directory → internal/ merge**: External repos have a `core/` subdirectory (between config and internal) with utility functions like `mux()`, `net()`. Existing dotfiles modules have no `core/` dir — these utilities belong in `internal/`. Contents of `core/` will be merged into `internal/` (e.g., `core/base.zsh` → additions to `internal/base.zsh`, or as a separate `internal/core.zsh` file if preferred).

6. **No external dependencies**: None of the 4 modules introduce new external dependencies beyond what ZSH already provides.

## Risks / Trade-offs

- [Factory removal risk] → Removing factory function wrappers could break if internal files reference their enclosing factory scope. Mitigation: the factory functions are immediately invoked (called at end of file), so they're equivalent to direct sourcing — safe to remove.
- [Path rename drift] → Renaming `ZSH_<NAME>_PATH` to `<NAME>_PATH` across all sourced files must be thorough. Mitigation: use a systematic find-and-replace per module.
- [Core → internal merge] → `core/` utility functions (`mux()`, `net()`) are simple aliases/functions with no complex scope. They can be safely appended to `internal/base.zsh` or kept as a separate `internal/core.zsh` file.
- [File count increase] → ~80 files added, but this is a one-time addition with no ongoing overhead.
- [Source repo drift] → If external repos are updated after migration, those updates won't be reflected here. Mitigation: source repos are preserved and can be re-synced if needed.
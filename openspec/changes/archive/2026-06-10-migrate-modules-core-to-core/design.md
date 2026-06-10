## Context

The dotfiles codebase has two living directories for core functionality:

- **`zsh/core/`** — Legacy flat config layer: 16 files providing basic zsh settings (history, language, autosuggest, paths), editor shortcuts, path management, and shell reload. Sourced directly from `.zshrc`. No idempotency guard, no namespacing, no package management.

- **`zsh/modules/core/`** — Modern modular rewrite (ported from `hadenlabs/zsh-core`): 20 files with proper `core::*` namespacing, idempotency guard, a 3-layer architecture (config/ → internal/ → pkg/), auto-installable tooling (eza, fzf, ripgrep, bat, jq), Docker CLI wrappers, git-aware backup, and Linux/macOS compatibility polyfills. Sourced via `modules/` convention from `.zshrc`.

Both are loaded at shell startup. The split creates confusion — contributors don't know where to add new core functionality, and the duplicate loader chains (`zsh/core/main.zsh` vs `zsh/modules/core/plugin.zsh`) add unnecessary maintenance surface.

## Goals / Non-Goals

**Goals:**
- Consolidate all `zsh/modules/core/` files into `zsh/zsh/` as the single source of truth
- Establish the 3-layer architecture (config/ → internal/ → pkg/) as the standard for all core functionality
- Preserve all existing `zsh/core/` files — nothing is removed from there
- Move ALL content from `zsh/modules/core/` into their logical places in `zsh/core/`
- Update `zsh/core/main.zsh` to be the single entry point with idempotency guard
- Remove `zsh/modules/core/` after migration
- Update any references in `.zshrc` or other modules that point to the old path

**Non-Goals:**
- Not changing the public API signatures of any `core::*` functions
- Not refactoring the internal implementation — pure structural migration
- Not adding new functionality beyond what `modules/core/` already provides
- Not changing the existing `zsh/core/` file contents (autosuggest, git, history, language, paths, editor, path, reload remain as-is)

## Decisions

### D1: 3-layer architecture with pkg/ added to zsh/core/

**Decision**: Add `pkg/` as a new subdirectory in `zsh/core/` alongside existing `config/` and `internal/`.

**Rationale**: The pkg/ layer encapsulates the public API (`core::install`, `core::load`, `core::exists`) and user-facing utilities (aliases, docker wrappers, helpers). This mirrors the established convention from `modules/core/` and other modules. Keeping it as a separate layer enforces the separation between internal implementation (internal/) and public interface (pkg/).

**Alternatives considered**:
- Flatten pkg/ content into existing core/ files — rejected because it would mix internal utilities with public API, making the API surface hard to identify
- Create pkg/ at a higher level — rejected because it belongs with the core it supports

### D2: Absorb plugin.zsh into main.zsh with idempotency guard

**Decision**: Merge `zsh/modules/core/plugin.zsh` into `zsh/core/main.zsh`. The main.zsh gains:
1. An idempotency guard (`[[ -n "${__ZSH_CORE_LOADED:-}" ]] && return`)
2. The `CORE_PATH` variable (pointing to `zsh/core/`)
3. The loader chain: config/ → internal/ → pkg/

**Rationale**: Having two entry points (`plugin.zsh` for modules, `main.zsh` for core) is confusing. Since core/ is the root, main.zsh should be THE entry point. The idempotency guard prevents double-loading.

**Alternatives considered**:
- Keep plugin.zsh as a wrapper that sources main.zsh — adds unnecessary indirection
- No idempotency guard — could cause issues if sourced twice

### D3: Preserve existing zsh/core/ files unchanged

**Decision**: All existing `zsh/core/` files remain exactly where they are. The migration only adds new files and updates `main.zsh`.

**Rationale**: The existing files handle essential zsh configuration (history, language, paths) that the modules/core/ layer doesn't touch. Moving or renaming them would create unnecessary churn and risk breaking something.

### D4: File mapping — modules/core/ → zsh/core/

Each file from `modules/core/` moves to a specific location in `zsh/core/`:

| Source (modules/core/) | Target (zsh/core/) | Notes |
|---|---|---|
| `plugin.zsh` | → merged into `main.zsh` | Absorb guard, CORE_PATH, loader chain |
| `config/base.zsh` | → `config/env.zsh` | Renamed for clarity |
| `config/main.zsh` | → merged into `config/main.zsh` | Add `env.zsh` to the existing source chain |
| `config/linux.zsh` | → `config/linux.zsh` | Already exists, merge content |
| `config/osx.zsh` | → `config/osx.zsh` | Already exists, merge content |
| `internal/base.zsh` | → `internal/api.zsh` | Renamed for clarity — contains core::internal::* |
| `internal/backup.zsh` | → `internal/backup.zsh` | Merge with existing backup.zsh |
| `internal/git.zsh` | → `internal/git.zsh` | New file — no existing counterpart |
| `internal/linux.zsh` | → `internal/linux.zsh` | Already exists, merge content |
| `internal/osx.zsh` | → `internal/osx.zsh` | Already exists, merge content |
| `internal/main.zsh` | → merged into `internal/main.zsh` | Add api.zsh, git.zsh to the source chain |
| `pkg/alias.zsh` | → `pkg/alias.zsh` | New directory/file |
| `pkg/base.zsh` | → `pkg/base.zsh` | New directory/file |
| `pkg/docker.zsh` | → `pkg/docker.zsh` | New directory/file |
| `pkg/linux.zsh` | → `pkg/linux.zsh` | New directory/file |
| `pkg/osx.zsh` | → `pkg/osx.zsh` | New directory/file |
| `pkg/main.zsh` | → `pkg/main.zsh` | New directory/file |
| `pkg/helper/backup.zsh` | → `pkg/helper/backup.zsh` | New directory/file |
| `pkg/helper/core.zsh` | → `pkg/helper/core.zsh` | New directory/file |
| `pkg/helper/main.zsh` | → `pkg/helper/main.zsh` | New directory/file |

### D5: Source path updates for moved files

**Decision**: All `source` paths within the moved files must be updated from `${CORE_PATH}/...` (which previously resolved to `zsh/modules/core/`) to use the new `CORE_PATH` pointing at `zsh/core/`.

**Rationale**: The `CORE_PATH` variable is set in the entry point. Since the entry point now lives in `zsh/core/`, `CORE_PATH` resolves there automatically. The source paths within files (e.g., `source "${CORE_PATH}/pkg/base.zsh"`) remain correct as long as they don't contain hardcoded paths.

## Risks / Trade-offs

- **[Risk] Missing a reference to `zsh/modules/core/`** → After deletion, any remaining reference will fail at shell startup. **Mitigation**: Search the entire repo for `modules/core` before deleting the directory.
- **[Risk] Source path mismatch** — Files from modules/core use relative sourcing; if `CORE_PATH` changes behavior, sources could break. **Mitigation**: All sources use `${CORE_PATH}/...` — as long as the variable is set correctly in main.zsh, they'll resolve.
- **[Risk] Ordering dependency** — The loader chain must source config/ before internal/ before pkg/. If a file in internal/ depends on something from pkg/, it will fail. **Mitigation**: Preserve the existing ordering from modules/core/plugin.zsh.
- **[Trade-off] Renamed files** — `config/base.zsh` → `config/env.zsh` and `internal/base.zsh` → `internal/api.zsh` improve clarity but could confuse anyone familiar with the old layout. The spec documents capture the final locations.
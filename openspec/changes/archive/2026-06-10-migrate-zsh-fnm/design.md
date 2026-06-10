## Context

`hadenlabs/zsh-fnm` is an external zsh plugin managed by antidote. It provides FNM (Fast Node Manager) installation, Node.js version management, and npm package management. The source already uses a layered architecture (`config/` → `core/` → `internal/` → `pkg/`) with factory-function dispatching and OS-specific stubs.

The monorepo has established a canonical module pattern (`zsh/modules/core/`, `zsh/modules/brew/`, `zsh/modules/rust/`) with:
- `plugin.zsh` entry point with idempotency guard
- `config/main.zsh` → `config/base.zsh` + OS files
- `internal/main.zsh` → `internal/base.zsh` + OS files + additional modules
- `pkg/main.zsh` → `pkg/base.zsh` (public API + auto-invoke) + OS files + alias
- Direct sourcing (no factory functions)

The source's `core/` layer is entirely empty stubs and can be dropped — the monorepo already provides `core::exists`, `core::install` via `zsh/modules/core/`.

## Goals / Non-Goals

**Goals:**
- Port all `fnm::*` function logic into `zsh/modules/fnm/` preserving exact namespaces
- Follow the monorepo three-layer source chain (config → internal → pkg) with OS dispatch
- Remove `hadenlabs/zsh-fnm` from `zsh/zsh_plugins.txt`
- Keep auto-install side-effect behavior (install fnm + curl + unzip if missing)

**Non-Goals:**
- No changes to function signatures or public API
- No changes to env var names or package lists
- No changes to the Node.js version management workflow
- No removal of the `core/` layer's empty files from the source repo (out of scope)

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Factory functions → direct sourcing | Direct sourcing | Matches `core`/`brew`/`rust` pattern; factory functions add unnecessary indirection in a monorepo |
| `core/` layer from source | Dropped | All stubs are empty; monorepo core module provides `core::exists` and `core::install` |
| Auto-invoke location | `pkg/base.zsh` (end) | Matches `brew` pattern — load happens after all functions defined |
| OS dispatch | Case statement in each `main.zsh` | Matches monorepo pattern; OS files are placeholders for future platform-specific logic |
| Variable export | `export` in `config/base.zsh` | Matches core module pattern; avoids shellcheck SC2034 false positives |
| Idempotency guard name | `__ZSH_FNM_LOADED` | Follows `__ZSH_CORE_LOADED` / `__ZSH_BREW_LOADED` convention |

## Risks / Trade-offs

- **Cross-file variable reference** → Same shellcheck SC2154 false positive as `brew` module. Mitigated by adding `# shellcheck disable=SC2154` at point of use, matching brew pattern.
- **Auto-install side-effect in subshell** → `fnm` auto-install triggers `curl | bash` which fails non-interactively. Same behavior as original plugin and all migrated modules. Only affects isolated subshell tests, not real shell sessions.
- **Empty placeholders** → OS and helper stubs are empty placeholders, consistent with `core`/`brew`/`rust` patterns and the original source. No risk.
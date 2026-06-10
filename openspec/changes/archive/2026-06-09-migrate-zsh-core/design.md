## Context

`hadenlabs/zsh-core` is a standalone Zsh plugin currently loaded via antidote in `zsh_plugins.txt`. It provides env vars, brew/cargo auto-install, messaging functions, fzf helpers, Docker CLI wrappers, eza aliases, Linux clipboard helpers, git URL parsing, and rsync project backup.

Migration moves the entire package into `zsh/modules/core/plugin.zsh` — a single self-contained module following the established `modules/` convention. No splitting across `mod/config/`, `mod/internal/`, or multiple modules.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/core/plugin.zsh` containing all zsh-core functionality
- Remove `hadenlabs/zsh-core` from `zsh_plugins.txt`
- Keep existing `mod/` unchanged

**Non-Goals:**
- No refactor of existing `mod/` structure
- No changes to `zshenv`
- No renaming of functions from `core::*` namespace — preserve public API names
- No splitting into multiple modules — keep as one cohesive package

## Decisions

1. **Single module** — The entire zsh-core lives in `modules/core/plugin.zsh`. This preserves the package's identity, keeps the migration simple, and avoids scattering related functionality across multiple locations.

2. **Flat plugin.zsh** — Unlike zsh-core's three-layer architecture (config/ → internal/ → pkg/), the module sources everything in a single file. Internal structure is collapsed.

3. **Idempotency guard** — Uses `__ZSH_CORE_LOADED` pattern to prevent double-sourcing.

4. **Preserve function namespace** — All `core::*` functions keep their existing names so existing usage elsewhere (e.g., `fzf-helpers` calling `core::exists`, `core::install`) continues working.

## Risks / Trade-offs

- **[Low] ANDROID_HOME not needed on all machines** — Env var always exported, negligible cost.
- **[Low] Install side-effects** — Auto-installs tools (axel, rg, fzf, jq, etc.) on shell start. This is existing behavior preserved.
- **[Low] Function name collision** — `core::*` functions from the module could clash with zsh-core still loaded via antidote during transition. Mitigation: remove zsh-core from `zsh_plugins.txt` in the same pass.

## Migration Plan

1. Create `zsh/modules/core/plugin.zsh` with all zsh-core functionality
2. Remove `hadenlabs/zsh-core` from `zsh_plugins.txt`
3. Verify in subshell (no errors, all functions available)

Rollback: restore `zsh_plugins.txt` line and remove `modules/core/`.

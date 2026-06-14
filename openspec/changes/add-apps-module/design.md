## Context

The dotfiles project manages shell configuration through zsh modules in `zsh/modules/`. Each module follows a strict three-layer architecture (config → internal → pkg) defined in `docs/guides/create-module.md`. The existing `zsh-apps` repository at `/home/lucho/Projects/src/github.com/luismayta/zsh-apps` manages desktop application installation across macOS and Linux using a 4-layer pattern (config → core → internal → pkg) with a factory-function approach.

The dotfiles already provide `zsh/core/` with cross-platform package management (`core::install`, `core::exists`, `message_*`), making the standalone `core/` layer redundant. This migration aligns `apps` with every other module in the project.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/apps/` following the guide's 16-file scaffold with all OS placeholder files
- Port categorized app lists from `zsh-apps` into `config/base.zsh` using the `<NAME>_PACKAGE_NAME` convention
- Implement `apps::internal::packages::install` that iterates `APPS_PACKAGES` and calls `core::install` for each
- Expose `apps::packages::install` and `apps::setup` as public API
- Add `apps` scope to `.goji.json`
- Register the module in the module loader
- Replace any `nativefiel`/`nativefier` references with `pake` in the app lists and functionality

**Non-Goals:**
- Not modifying existing `zsh/core/` — shared infrastructure stays unchanged
- Not porting the factory-function pattern (each layer's `main.zsh` auto-sources inline per the guide)
- Not implementing `apps::upgrade` (left as a warning stub, matching current behavior)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Layer architecture | 3-layer (config → internal → pkg) | Matches guide and all existing modules; core/ is shared via `zsh/core/` |
| OS files | Always present as placeholders | Documents platform contract; follows guide Section 6 |
| App lists | Sourced directly in `config/base.zsh` | Same as zsh-apps; keeps categories visible in a single file |
| Install mechanism | `core::install` per app | Delegates to `paru`/`brew` via `zsh/core/` — no custom install logic needed |
| Module loader registration | Add to `zsh/loader.zsh` or equivalent | Matches how `zed` and other modules are registered |
| Scope name | `apps` | Lowercase, matches module directory name |
| pake integration | Add as a category or install target in APPS_PACKAGES | pake wraps web apps as native desktop apps via Rust+Tauri |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| App list grows stale (apps renamed, deprecated) | `core::install` fails gracefully per app; no single point of failure |
| pake requires Node.js and Rust build toolchain | Document prerequisites; `core::ensure` covers Node.js if needed |
| Large app list slows shell startup | `core::exists` check per app is fast (~1ms each); list has ~30 items |
| Factory pattern removal breaks sourcing order | OS dispatch in each `main.zsh` preserves the same loading order as zsh-apps |

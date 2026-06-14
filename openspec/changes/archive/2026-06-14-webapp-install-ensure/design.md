## Context

The `apps` module has two separate flows:
- **Packages**: `internal/base.zsh` (implementation) → `pkg/base.zsh` (public wrapper `apps::packages::install()`)
- **Webapps**: `internal/build.zsh` (implementation) → `pkg/base.zsh` (public wrappers `apps::webapp::build()`, `apps::webapp::install()`)

The webapp logic lives in `build.zsh` but the functions are about webapp lifecycle (build + install), not just building. The naming is misleading. There's also no "ensure all webapps" function analogous to `apps::internal::packages::install()`.

The `APPS_WEB_APPS_BUILD` array uses `Name:url` format (e.g., `"Jira:https://codip.atlassian.net"`).

## Goals / Non-Goals

**Goals:**
- Extract webapp functions from `build.zsh` → dedicated `internal/webapp.zsh`
- Add `apps::internal::webapp::all::install()` — iterate `APPS_WEB_APPS_BUILD` and ensure each webapp is built+installed
- Add `apps::internal::webapp::ensure()` — build+install a single webapp by name
- Add public wrappers in `pkg/base.zsh`: `apps::webapp::all::install()` and `apps::webapp::ensure()`
- Mirror the `packages::install()` KISS pattern exactly

**Non-Goals:**
- Change the existing `build()` or `install()` single-entry functions
- Alter the `APPS_WEB_APPS_BUILD` data format
- Add new dependencies

## Decisions

| Decision | Rationale |
|---|---|
| Extract to `webapp.zsh` not `build.zsh` | The file manages webapp lifecycle (build+install), not just building. Cleaner separation of concerns. |
| Public wrapper in `pkg/base.zsh` | Matches the `apps::packages::install()` pattern — thin public API, implementation in `internal/` |
| New `ensure()` calls existing `build()` + `install()` | Reuses proven logic; no duplication. `build()` runs first if artifact missing, then `install()` |
| Keep `APPS_WEB_APPS_BUILD` Name:url format unchanged | Consistent with existing config; no migration needed |

## Architecture

```
internal/
├── base.zsh       # apps::internal::packages::install() — package install logic
├── webapp.zsh     # webapp build + install + ensure (extracted from build.zsh, replaces it)
└── main.zsh       # sources webapp.zsh instead of build.zsh
pkg/
├── base.zsh       # apps::packages::install() + apps::webapp::all::install() + apps::webapp::ensure()
```

## Risks / Trade-offs

- **Low risk**: Pure refactor — existing public API signatures unchanged, only internal file structure changes
- **Build on every ensure**: Currently no cache check — if artifact exists, `build()` will skip via its own logic (it checks existence via `find` before rename)

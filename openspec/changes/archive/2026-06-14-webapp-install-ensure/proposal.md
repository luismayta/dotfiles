## Why

`apps::internal::webapp::all::build()` and `apps::internal::webapp::install()` are separate steps — you build first, then install. There's no single "ensure" function that builds and installs a webapp only if missing. This creates friction: you must know the two-step flow, and there's no idempotent entry point analogous to `apps::internal::packages::install()` / `core::ensure`.

## What Changes

- **Extract** all webapp functions from `internal/build.zsh` → new `internal/webapp.zsh`
- **Add** `apps::internal::webapp::all::install()` — iterates `APPS_WEB_APPS_BUILD` (format `Name:url`) and ensures each webapp is built and installed
- **Add** `apps::internal::webapp::ensure()` — builds and installs a single webapp by name
- **Add** public wrappers in `pkg/base.zsh`: `apps::webapp::all::install()` and `apps::webapp::ensure()` (mirroring `apps::packages::install()` pattern)
- **Update** `internal/main.zsh` to source `webapp.zsh`
- `internal/build.zsh` is either removed or trimmed down (all webapp functions move out)

## Capabilities

### New Capabilities
- `webapp-ensure-install`: single command to ensure all configured webapps are built and installed, equivalent to `packages::install` but for `APPS_WEB_APPS_BUILD`

### Modified Capabilities

None — no existing spec changes.

## Impact

- `zsh/modules/apps/internal/build.zsh` — removed (all functions moved to webapp.zsh)
- `zsh/modules/apps/internal/webapp.zsh` — new file (extracted + new functions)
- `zsh/modules/apps/internal/main.zsh` — add source for webapp.zsh
- `zsh/modules/apps/pkg/base.zsh` — add public wrappers
- No breaking changes to existing APIs

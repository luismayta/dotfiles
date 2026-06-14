## Context

The apps module manages desktop application installation following a two-layer convention:
- **Internal** (`internal/base.zsh`): implements the actual logic (`apps::internal::<name>`)
- **Public** (`pkg/base.zsh`): thin delegation functions (`apps::<name>`)

Config is declared in `config/base.zsh` with exported variables and consumed by internal functions. `pake` (the CLI tool to build native desktop apps from web URLs) is already declared in `APPS_WEB_APPS` on macOS (`brew`) and managed via the apps packages install flow. However, there is no function to build new web apps declaratively.

The `pake` CLI command invoked will be:
```
pake <url> --name <name> --width 1200 --height 800 --hide-title-bar --targets zst
```

## Goals / Non-Goals

**Goals:**
- Add `APPS_WEB_APPS_BUILD` config array in `config/base.zsh` listing web apps to build (as `name:url` pairs)
- Add `apps::internal::webapp::build <url> <name>` to build a single web app via pake
- Add `apps::internal::webapp::all::build` to build all configured web apps
- Add corresponding public functions `apps::webapp::build` and `apps::webapp::all::build` in `pkg/base.zsh`

**Non-Goals:**
- Not modifying `pake` installation logic (already in `APPS_WEB_APPS`)
- Not modifying existing `APPS_WEB_APPS` array
- Not adding per-app custom pake flags (width/height/targets are hardcoded defaults)
- Not implementing uninstall or cleanup of previously built web apps

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Config format | `name:url` colon-separated strings in a flat array | Simple to parse with `${entry#*:}` / `${entry%%:*}`; no associative array dependency; easy to extend later |
| Arg order for build | `apps::webapp::build <url> <name>` | Matches pake CLI argument order; consistent with other zsh module functions |
| Default pake flags | `--width 1200 --height 800 --hide-title-bar --targets zst` | Hardcoded in the internal function; configurable later if needed |
| Error handling | Validate both arguments are non-empty; return 1 with `message_error` on failure | Follows existing `apps::internal::packages::install` pattern |
| Naming | `webapp::build` (singular) / `webapp::all::build` (batch) | Consistent with `fnm::internal::package::install` / `fnm::internal::packages::install` naming distinction |

## Risks / Trade-offs

- **Risk: pake not installed** → Mitigation: pake is in `APPS_WEB_APPS` and gets installed via `apps::packages::install`; the build function should check `core::exists pake` before attempting
- **Risk: Build failure (network, invalid URL)** → Mitigation: `pake` CLI handles its own errors; the function checks the exit code and reports via `message_error`
- **Risk: `name:url` format collision** → Mitigation: names and URLs are unlikely to contain colons in the name field; if needed, escaping can be added later

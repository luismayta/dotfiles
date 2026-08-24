## Context

The module syncs with a single unconditional rsync (`internal/base.zsh`): everything under `data/` lands in `~/.hammerspoon/`, including the tracked `data/custom.lua`. The Lua side already treats `custom.lua` as the highest-priority merge layer (`src/core/config/loader.lua` uses `safeRequire("custom")`), but the sync overwrites the file on every run and `require("custom")` is ambiguous because `init.lua` adds `<configdir>/src/?.lua` to `package.path` while Hammerspoon's built-in setup also exposes `<configdir>/?.lua`. Per product decision, the user override moves to `~/.config/hammerspoon/custom.lua` while the rest of the configuration stays in `~/.hammerspoon`. See proposal.md for motivation.

Constraint discovered during research: Hammerspoon has no native XDG support (maintainer declined, issue #1925) and, as a GUI application, it does not inherit shell environment variables — the Lua side must derive paths from `os.getenv("HOME")`, not from module variables.

## Goals / Non-Goals

**Goals:**
- `~/.config/hammerspoon/custom.lua` is the single, user-owned override location that no sync can touch
- A fresh machine gets a usable seeded `custom.lua` without shipping a live file in the repo
- One and only one resolution path for `require("custom")`
- Repository tracks an example only

**Non-Goals:**
- Migrating the whole Hammerspoon configuration to `~/.config/hammerspoon` (rejected: requires `MJConfigFile` defaults-key surgery for the entire tree; product chose override-only relocation)
- Generating `custom.lua` content from a gomplate template (owned by the sibling change `improve-hammerspoon-config`)
- Changing any public module function signature

## Decisions

1. **Structural protection via relocation** — the override lives outside the rsync destination, so no exclusion flags are needed; the sync physically cannot reach it.
   - *Alternative considered*: keep the file in `~/.hammerspoon` and protect it with `--exclude` flags — rejected: one refactoring away from silent clobbering, and user files would sit inside a directory the module owns.

2. **Seed-if-missing in the module sync** — before rsync, ensure `~/.config/hammerspoon/` exists and copy `custom.lua.example` to `custom.lua` there only when absent. The location is exposed as `ZSH_HAMMERSPOON_CUSTOM_DIR` in the config layer per the module architecture guide.
   - *Alternative considered*: seed during `post_install` only — rejected: users running bare `hammerspoon::sync` would get no seed.

3. **Resolve via `package.path` prepend in `init.lua`** — prepend `os.getenv("HOME") .. "/.config/hammerspoon/?.lua"` ahead of all entries before any `require` executes, so `require("custom")` deterministically hits the override directory while keeping `safeRequire` semantics intact.
   - *Alternative considered*: explicit `dofile` of an absolute path inside `loader.lua` — more forceful but bypasses standard Lua module semantics and spreads path knowledge across files.
   - *Alternative considered*: reading the module's shell variable from Lua — impossible reliably: GUI apps do not inherit shell environments.

4. **Rename tracked `data/custom.lua` to `data/custom.lua.example` and clean `.gitignore`** — the example is the seed source; the live file exists only off-repo. Stale ignore entries (`src/custom.lua`) are removed since neither path is relevant anymore.

## Risks / Trade-offs

- [Legacy `~/.hammerspoon/custom.lua` left behind on existing machines] → It is inert once resolution points at the new location; the sync emits an informational message when a legacy file is detected so users can migrate manually.
- [`os.getenv("HOME")` returning nil] → Practically impossible under macOS launchd; the prepend is skipped harmlessly if nil, falling back to current behavior.
- [Users expect edits in the old location to take effect] → Resolution order makes the new location win; the informational message covers discovery.

## Migration Plan

1. Land rename, config variable, seed step, and `package.path` pin together so no intermediate state can clobber or orphan the override.
2. On each machine: run `hammerspoon::sync` once — fresh machines get seeded; existing machines see the legacy-file notice and manually move their content to `~/.config/hammerspoon/custom.lua`.
3. Rollback: revert the commit; resolution returns to previous ambiguous-but-working form.

## Open Questions

None.

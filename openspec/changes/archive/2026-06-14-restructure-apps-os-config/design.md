## Context

The apps module has three config files loaded by `main.zsh`:

```
main.zsh  →  base.zsh (always)
          →  osx.zsh   (when $OSTYPE = darwin*)
          →  linux.zsh (when $OSTYPE = linux*)
```

Currently `base.zsh` defines `APPS_<CATEGORY>__DARWIN` and `APPS_<CATEGORY>__LINUX` suffix arrays for every category, plus an OSTYPE resolution block that copies the correct suffix to a bare `APPS_<CATEGORY>` array. This means every app name is declared twice in the same file, and categories where both OS share the same name (e.g., `APPS_IDE_TOOLS__DARWIN=(tig meld)`, `APPS_IDE_TOOLS__LINUX=(tig meld)`) repeat identical data.

Since `main.zsh` already dispatches by `$OSTYPE`, the OS-specific files (`osx.zsh` / `linux.zsh`) are the natural home for their respective package names. The `__DARWIN`/`__LINUX` layer is an unnecessary indirection.

## Goals / Non-Goals

**Goals:**
- Eliminate `__DARWIN`/`__LINUX` suffix arrays and the OSTYPE resolution block from `base.zsh`
- Move OS-specific package names to the respective OS config file
- Keep apps with identical package names across OS in `base.zsh` (declared once)
- Preserve `APPS_PACKAGES` aggregate behavior unchanged

**Non-Goals:**
- No functional changes to how APPS_PACKAGES is consumed downstream
- No changes to `main.zsh` (its OS dispatch is correct and unchanged)
- No changes to the goenv module or any other module

## Decisions

### Decision 1: Per-category arrays in OS files instead of monolithic lists
**Chosen:** Each OS-specific file declares the same `APPS_<CATEGORY>` arrays as `base.zub` for categories where names differ.
**Alternative:** Single `APPS_PACKAGES` list in OS files. Rejected because it breaks the category abstraction — consumers couldn't query `APPS_DEVOPS` independently.
**Alternative:** One array per OS file per category with `_OSX`/`_LINUX` suffix (current `osx.zsh` pattern). Rejected — since `main.zsh` already scopes by OS, bare names are unambiguous.

### Decision 2: OS-specific files use `APPS_PACKAGES+=()` for extras
**Chosen:** `osx.zsh` and `linux.zsh` append their exclusive apps (raycast, unite, orbstack) to `APPS_PACKAGES` via `+=`, just as `osx.zsh` does today.
**Rationale:** Exclusive apps have no category home — they augment the aggregate without requiring a new category array.

### Decision 3: Categories with identical names on both OS stay in base.zsh
**Chosen:** `tig`, `meld`, `discord`, `android-studio`, `android-platform-tools`, `openvpn`, `jira-cli` are identical brew/AUR names and stay in `base.zsh`.
**Rationale:** No duplication, single source of truth. If a future OS diverges, the app moves to the OS file.

### Decision 4: Remove file-level `_OSX` array suffix pattern from osx.zsh
**Chosen:** The current `_APPS_DEVOPS_OSX=()` pattern in `osx.zsh` is replaced with direct category arrays matching the base.zsh style.
**Rationale:** Consistency — all category arrays use the same `APPS_<CATEGORY>` naming regardless of which file they live in.

## Risks / Trade-offs

- **[Low risk] Duplicate definitions if category overlaps** → If the same app name appears in both `base.zsh` and the OS file, the OS file's `APPS_<CATEGORY>+=()` would double it. Mitigation: naming convention — base.zsh owns cross-OS apps, OS files own OS-specific names, no overlap by design.
- **[Low risk] linux.zsh renamed from placeholder** → Currently `linux.zsh` is an empty placeholder. This change populates it with actual package data. No rollback issue — the old content was empty.
- **[Low risk] osx.zsh restructured** → The exclusive apps (raycast, unite, etc.) currently use `_OSX` suffix arrays. They migrate to direct `APPS_<CATEGORY>+=()` calls. Since `osx.zsh` is only sourced on macOS, the behavior is identical.

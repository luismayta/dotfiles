Part of: `add-pandoc-core`

The old docker alias was removed from `docker.zsh` in a prior change, leaving no pandoc integration. The `CORE_PACKAGES` arrays also lacked structural organization — a flat list that mixed system tools, dev deps, fonts, and utilities without grouping.

Following the pattern established in `zsh/modules/herdr/config/base.zsh` where `ZSH_HERDR_INSTALL_PLUGINS` is organized by comment-delimited categories:
```zsh
# Orchestrate & Run — agent coordination, factories, pipelines
ZSH_HERDR_INSTALL_PLUGINS+=(...)
# Connect — socket API, MCP, notifications, bridges
ZSH_HERDR_INSTALL_PLUGINS+=(...)
```

## What Changed

### 1. Categorized `CORE_PACKAGES`

Both `osx.zsh` and `linux.zsh` now group packages under category comments:
```zsh
CORE_PACKAGES=(
  # Category Name
  pkg1
  pkg2

  # Next Category
  pkg3
  pkg4
)
```

Categories are defined by functional domain, not by package manager or origin.

### 2. Added pandoc

- **macOS**: `pandoc` (brew formula)
- **Arch Linux**: `pandoc-cli` (extra repo, CLI-only package)

Platform configs already use different package names for the same tool (e.g., fonts). No new patterns needed.

## Design Decisions

### Decision 1: Category grouping by function, not source

- Categories reflect what the packages *do* (Clipboard, Audio, Fonts), not where they come from (brew, paru)
- This makes it obvious what's available and where to add new packages

### Decision 2: Preserved all existing packages including duplicates

- `fd` appears twice in linux.zsh (original had it at line 19 and 35) — preserved in both CLI Utilities and Media & Utilities
- No packages removed, no order changed within categories

### Decision 3: pandoc follows the existing naming pattern

- `pandoc` (brew) / `pandoc-cli` (paru) — same pattern as fonts where names differ per platform

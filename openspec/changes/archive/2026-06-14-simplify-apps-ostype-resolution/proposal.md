## Why

The OSTYPE resolution block in `zsh/modules/apps/config/base.zsh` currently spans 41 lines (89–129) with 36 near-identical array assignments: 12 categories × 3 branches (darwin/linux/fallback). This is verbose, repetitive, and fragile — adding a new app category requires touching 4 separate locations (DARWIN array, LINUX array, 3 resolution branches, and APPS_PACKAGES aggregate). A single omission breaks the module silently.

Zsh's `nameref` (typeset -n) provides a clean indirection mechanism to replace the 36-line block with a declarative category list + a 7-line loop, making the resolution block order-of-magnitude more maintainable.

## What Changes

- **Refactor** the OSTYPE resolution block in `zsh/modules/apps/config/base.zsh`:
  - Replace the current 3-branch × 12-category if/elif/else block with a category name list + loop using zsh `nameref`
  - Preserve the exact same resolved `APPS_<CATEGORY>` arrays and `APPS_PACKAGES` aggregate
  - Zero behavior change — purely structural refactor

## Capabilities

### New Capabilities

*(none — this is a pure implementation refactor with no new capability)*

### Modified Capabilities

*(none — no requirement changes)*

## Impact

- **Modified file**: `zsh/modules/apps/config/base.zsh` — OSTYPE resolution block simplified
- **No API change**: All `APPS_<CATEGORY>` variables and `APPS_PACKAGES` behave identically
- **No spec change**: Internal refactor, requirements unchanged
- **No dependency change**: Uses only built-in zsh features (`nameref`, standard parameter expansion)

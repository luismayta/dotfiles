## Context

The `apps` module manages desktop application installation via `APPS_PACKAGES`. Its `apps::internal::packages::install()` function iterates over all packages and calls `core::install` unconditionally. The `core` module already provides `core::ensure()` which guards installation behind an existence check (`core::exists "${1}" || core::install "${1}"`), defined in `zsh/core/pkg/base.zsh:18-20`.

The pattern of using `core::ensure` is already established in this module — `zsh/modules/apps/internal/main.zsh:13` calls `core::ensure curl`. Other modules (git, devops, nvim, etc.) follow the same convention.

## Goals / Non-Goals

**Goals:**
- Skip installation of already-present packages in `apps::internal::packages::install()`
- Reduce console noise and execution time for repeated runs
- Align with existing codebase conventions

**Non-Goals:**
- Change the public API or function signature
- Alter installation behavior for missing packages
- Modify other modules or their patterns

## Decisions

| Decision | Rationale |
|---|---|
| Use `core::ensure` over manual `if ! core::exists` guard | `core::ensure` is the idiomatic wrapper already used across the codebase. It encapsulates the check-and-install pattern in one call, making the code more concise and consistent. |
| Single-line change only | The function body is simple — a one-line replacement. No structural refactor needed. |

## Risks / Trade-offs

- **Low risk**: `core::ensure` is a well-established function (24+ usages across the codebase). The change is trivially revertible.
- **No breaking changes**: The function's contract ("install required packages") is preserved; only the no-op case becomes silent.

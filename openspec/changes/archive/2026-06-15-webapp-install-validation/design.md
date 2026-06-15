## Context

`apps::internal::webapp::all::install()` and `apps::internal::webapp::ensure()` attempt idempotent install by checking `paru -Qi "${name}"` on Linux. This check is unreliable because:

1. `paru -Qi` queries the pacman database by package name, but the name embedded in `pake`'s `.pkg.tar.zst` output does not always match the `${name}` from `APPS_WEB_APPS_BUILD`.
2. The artifact is renamed to lowercase (`${(L)name}.pkg.tar.zst`) but the package metadata inside still uses the original name, creating a mismatch.
3. macOS has no idempotency check at all — it always runs `open` on the `.app` bundle.

The result is that `all::install()` rebuilds and reinstalls every webapp on every invocation, defeating idempotency.

## Goals / Non-Goals

**Goals:**
- Replace the `paru -Qi` check with `core::exists` using the correct command name that `pake` installs (`core::exists pake-${(L)name}`)
- Apply the same fix to both `all::install()` and `ensure()` (identical pattern)
- Add a macOS idempotency check using `core::exists` on the app bundle binary

**Non-Goals:**
- Change how `pake` builds or how artifacts are named
- Alter the `APPS_WEB_APPS_BUILD` data format or function signatures
- Add new dependencies

## Decisions

| Decision | Rationale |
|---|---|
| Use `core::exists pake-${(L)name}` instead of `paru -Qi` | `core::exists` checks `command -v` which queries PATH — the pake-installed binary is available as a command. Lowercase matches the artifact rename convention. |
| Same check for macOS via `open -Ra` or checking the `.app` bundle path | `command -v` won't find `.app` bundles; use `core::exists` on the binary inside the app or `[ -d "${APPLICATION_PATH}/${name}.app" ]` instead. |
| Extract into a helper `apps::internal::webapp::is_installed()` | Avoids duplicating the OSTYPE switch + check logic in both `all::install()` and `ensure()`. Clean separation. |

## Risks / Trade-offs

- **Low risk**: Pure idempotency fix — no API signatures change, only the validation gate before install.
- **Binary name uncertainty**: If `pake` changes its naming convention (e.g., drops the `pake-` prefix), the check breaks. Mitigation: document the assumption in the function comment.

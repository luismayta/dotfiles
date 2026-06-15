## Why

`apps::internal::webapp::all::install()` and `apps::internal::webapp::ensure()` check if a webapp is already installed via `paru -Qi "${name}"`. This check is unreliable — paru registers the package under the name embedded in the `.pkg.tar.zst` by `pake`, which doesn't always match the `${name}` from `APPS_WEB_APPS_BUILD`. As a result, the check always fails and the install runs every time ("instala a lo tonto"). On macOS there is no check at all.

## What Changes

1. Replace the `paru -Qi "${name}"` idempotency check in `all::install()` with `core::exists` using the correct binary name that pake installs (e.g., `core::exists pake-${(L)name}`).
2. Apply the same fix to `ensure()` which has the identical pattern.
3. Add a similar idempotency check for macOS using `core::exists` (checking the app bundle path).

No new capabilities — pure bug fix to existing idempotency checks.

## Capabilities

### New Capabilities

None — bug fix to existing implementation.

### Modified Capabilities

None — behavior is unchanged (still idempotent), only the validation method changes.

## Impact

- `zsh/modules/apps/internal/webapp.zsh` — modify `all::install()` and `ensure()` validation checks
- No new dependencies, no API signature changes

## Why

`pake` does not support `--target-path`. It always writes the compiled artifact (`.pkg.tar.zst`) to the current working directory. Currently `apps::internal::webapp::build()` runs `pake` without first changing to `${APPS_WEB_APPS_BUILD_DIR}`, so the artifact lands in the user's cwd instead of the build directory. The subsequent `find` + rename in `APPS_WEB_APPS_BUILD_DIR` fails because the file isn't there — the webapp build appears to succeed but the artifact is lost.

## What Changes

1. **`apps::internal::webapp::build()`** — replace the removed `--target-path` approach with a `cd` to `${APPS_WEB_APPS_BUILD_DIR}` before invoking `pake`. Restore the original cwd after the `pake` call using `pushd`/`popd`.
2. **`apps::internal::webapp::all::build()`** — no longer needs to `mkdir -p` the build dir before the loop (the build function handles it now). Keep cleanup but ensure entry into the directory is handled by `build()`.

No new capabilities, no spec changes — pure bug fix.

## Capabilities

### New Capabilities

None — bug fix to existing implementation.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `zsh/modules/apps/internal/webapp.zsh` — modify `apps::internal::webapp::build()` to `cd` into build dir before running `pake`
- No new dependencies, no API signature changes

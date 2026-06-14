## Context

The `apps` module currently has `APPS_WEB_APPS_BUILD` declared in config and stub `webapp::build` / `webapp::all::build` functions in `internal/base.zsh`. The existing `webapp::build` invokes `pake` directly in CWD with partial flags — no build directory management, no artifact renaming, and no install step. This design completes the pipeline so that a single `apps::webapp::all::build` produces installed desktop wrappers.

The module follows a 3-layer architecture: `config/` (env vars), `internal/` (implementation), `pkg/` (public API). The new build workflow fits into the existing internal layer.

## Goals / Non-Goals

**Goals:**
- Provide a configurable per-OS build directory via `APPS_WEB_APPS_BUILD_DIR`
- Complete `apps::internal::webapp::build` with: directory creation, `pake` with `--hide-menu`, artifact rename, install
- Provide `apps::internal::webapp::install` for post-build installation (Linux: `paru -U`, macOS: `open`)
- Wire everything through the existing `webapp::all::build` loop
- Expose `apps::webapp::install` in the public pkg layer

**Non-Goals:**
- Cross-platform build matrix (no Windows support)
- Parallel builds (sequential is sufficient for small sets)
- Webapp config editing at runtime (config is static zsh arrays)
- Caching or incremental builds (always clean build)

## Decisions

1. **APPS_WEB_APPS_BUILD_DIR defaults to `/tmp/pake-build` on both platforms**
   - Rationale: Linux and macOS both have `/tmp/` writable; keeping it uniform avoids conditional complexity. Overridable via config OS files if needed in the future.
   - Alternative considered: `$HOME/.cache/pake-build` — rejected because pake artifacts are large and ephemeral; `/tmp` is cleaner for disposable build outputs.

2. **Artifact rename uses `mv` with glob pattern on the output directory**
   - Rationale: `pake --targets zst` outputs a timestamped filename like `Jira_2024-01-01_x86_64.pkg.tar.zst`. The exact filename is unpredictable, so we glob-match `"${name}"*.pkg.tar.zst` after build and rename to a canonical `${name:l}.pkg.tar.zst`.
   - Alternative considered: Parsing pake output for filename — rejected as fragile across pake versions.

3. **Install is OS-dispatched in the internal layer**
   - Linux: `paru -U` (AUR helper for local packages)
   - macOS: `open` (opens the app bundle)
   - Rationale: Installation mechanism differs fundamentally per OS; internal layer already has OS dispatch via `internal/osx.zsh` and `internal/linux.zsh`.

4. **Build and install are separate steps**
   - Rationale: Allows building all apps first, reviewing artifacts, then installing. `webapp::all::build` builds all but does not auto-install; install is explicit.

5. **Clean build directory at start of each `all::build` run**
   - Rationale: Avoid stale artifacts from previous runs. `rm -rf "${APPS_WEB_APPS_BUILD_DIR}" && mkdir -p "${APPS_WEB_APPS_BUILD_DIR}"` before the loop.

## Risks / Trade-offs

- **pake CLI flag drift**: `--hide-menu` and `--targets zst` may change across pake versions. Mitigation: pin pake version in package manifest or document as known constraint.
- **Glob rename ambiguity**: If pake outputs multiple `*.pkg.tar.zst` files per build, `mv` may fail. Mitigation: loop with `for f in ...` and take first match; log warning if >1 found.
- **paru required on Linux**: `paru` must be installed for the install step. Mitigation: `apps::internal::webapp::install` checks `core::exists paru` and logs a clear error if missing, skipping that entry.

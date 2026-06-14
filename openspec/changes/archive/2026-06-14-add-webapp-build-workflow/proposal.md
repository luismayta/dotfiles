## Why

The `apps` module already declares `APPS_WEB_APPS_BUILD` with web app entries (Jira, ChatGPT) and has stub build functions in `internal/base.zsh`, but the full build workflow is incomplete — there's no configurable build directory, no post-build artifact management (rename, move), and no install step. Without this, the webapp build pipeline cannot be used end-to-end.

## What Changes

- Add `APPS_WEB_APPS_BUILD_DIR` environment variable (configurable per OS: Linux uses `/tmp/pake-build`, macOS uses `/tmp/pake-build`)
- Update `apps::internal::webapp::build` to create the build directory, run `pake` inside it, rename the output artifact, and install it
- Add `--hide-menu` flag to the `pake` invocation (currently missing)
- Add `apps::internal::webapp::install` function to install the built package (Linux: `paru -U`, macOS: `open`)
- Create `internal/build.zsh` for build-specific internal functions
- Wire the new build logic into `internal/main.zsh`
- Add Linux-specific build path in `config/linux.zsh`
- Update `pkg/base.zsh` to expose new public API functions

## Capabilities

### New Capabilities
- `webapp-build`: Full build workflow for pake desktop wrappers — directory creation, pake invocation with all flags, artifact renaming, and installation

### Modified Capabilities
- (none — existing webapp stubs have no spec-defined requirements yet)

## Impact

- **zsh/modules/apps/config/base.zsh** — add `APPS_WEB_APPS_BUILD_DIR`
- **zsh/modules/apps/config/linux.zsh** — add Linux-specific `APPS_WEB_APPS_BUILD_DIR`
- **zsh/modules/apps/config/osx.zsh** — add macOS-specific `APPS_WEB_APPS_BUILD_DIR`
- **zsh/modules/apps/internal/base.zsh** — update `webapp::build` with full workflow; add `webapp::install`
- **zsh/modules/apps/internal/main.zsh** — source new `build.zsh` if created
- **zsh/modules/apps/pkg/base.zsh** — expose `apps::webapp::install`
- **zsh/modules/apps/data/** — may store build logs or cached state

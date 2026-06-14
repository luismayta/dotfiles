## 1. Configuration Layer

- [x] 1.1 Add `APPS_WEB_APPS_BUILD_DIR` to `config/base.zsh` with default `/tmp/pake-build`
- [x] 1.2 Add `APPS_WEB_APPS_BUILD_DIR` override to `config/linux.zsh` (also `/tmp/pake-build`)
- [x] 1.3 Add `APPS_WEB_APPS_BUILD_DIR` override to `config/osx.zsh` (also `/tmp/pake-build`)

## 2. Internal Implementation — build workflow

- [x] 2.1 Create `internal/build.zsh` with `apps::internal::webapp::build` and `apps::internal::webapp::install` functions
- [x] 2.2 Implement `apps::internal::webapp::build`: create build dir, `cd` into it, run `pake` with `--hide-menu`, rename artifact to canonical name
- [x] 2.3 Implement `apps::internal::webapp::install` with OS dispatch: Linux `paru -U`, macOS `open`
- [x] 2.4 Update `internal/main.zsh` to source `build.zsh` before the OS dispatch
- [x] 2.5 Remove duplicate `webapp::build` and `webapp::all::build` from `internal/base.zsh` (moved to `build.zsh`)

## 3. Public API Layer

- [x] 3.1 Add `apps::webapp::install` to `pkg/base.zsh` delegating to `apps::internal::webapp::install`
- [x] 3.2 Add function documentation to `pkg/base.zsh`

## 4. Verification

- [x] 4.1 Run `task validate` to confirm shellcheck and pre-commit hooks pass
- [x] 4.2 Verify `type apps::webapp::build` and `type apps::webapp::install` return "function"
- [x] 4.3 Verify `echo $APPS_WEB_APPS_BUILD_DIR` outputs `/tmp/pake-build` or custom override

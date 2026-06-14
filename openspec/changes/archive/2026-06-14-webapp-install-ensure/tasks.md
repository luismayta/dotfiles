## 1. Extract webapp logic to dedicated file

- [ ] 1.1 Create `zsh/modules/apps/internal/webapp.zsh` — move all webapp functions (build, all::build, install) from `build.zsh`
- [ ] 1.2 Add `apps::internal::webapp::all::install()` and `apps::internal::webapp::ensure()` to `webapp.zsh`
- [ ] 1.3 Update `internal/main.zsh` to source `webapp.zsh` (replace or complement `build.zsh`)
- [ ] 1.4 Remove `internal/build.zsh` — all functions moved to `webapp.zsh`

## 2. Add public wrappers in pkg/

- [ ] 2.1 Add `apps::webapp::all::install()` and `apps::webapp::ensure()` to `zsh/modules/apps/pkg/base.zsh`
- [ ] 2.2 Consistent with `apps::packages::install()` pattern

## 3. Verification

- [ ] 3.1 Source the module and verify all functions work
- [ ] 3.2 Run `task validate` to confirm no shellcheck regressions

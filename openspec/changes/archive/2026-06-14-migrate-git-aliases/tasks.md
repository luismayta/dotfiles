## 1. Migrate git config

- [x] 1.1 Create `zsh/modules/git/config/git.zsh` with `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1`
- [x] 1.2 Add `source "${ZSH_GIT_PATH}/config/git.zsh"` to `zsh/modules/git/config/main.zsh`
- [x] 1.3 Remove `source "${DOTFILES_CORE_PATH}/config/git.zsh"` from `zsh/core/config/main.zsh`

## 2. Migrate git internal function

- [x] 2.1 Create `zsh/modules/git/internal/get-module-path.zsh` with `git::internal::get_module_path()` (ported from `core::git::get_module_path`)
- [x] 2.2 Add `source "${ZSH_GIT_PATH}/internal/get-module-path.zsh"` to `zsh/modules/git/internal/main.zsh`
- [x] 2.3 Remove `source "${DOTFILES_CORE_PATH}/internal/git.zsh"` from `zsh/core/internal/main.zsh`
- [x] 2.4 Update `zsh/core/internal/backup.zsh` to call `git::internal::get_module_path` instead of `core::git::get_module_path`

## 3. Migrate git fzf helpers

- [x] 3.1 Create `zsh/modules/git/pkg/fzf.zsh` with `fcs()` and `fgb()` functions (ported from `zsh/core/pkg/helper/core.zsh`)
- [x] 3.2 Add `source "${ZSH_GIT_PATH}/pkg/fzf.zsh"` to `zsh/modules/git/pkg/main.zsh`
- [x] 3.3 Remove `fcs()` and `fgb()` function definitions from `zsh/core/pkg/helper/core.zsh`

## 4. Verification

- [x] 4.1 Run `task validate` to ensure pre-commit hooks and format checks pass
- [x] 4.2 Verify `git::internal::get_module_path` works with SSH and HTTPS remote URLs
- [x] 4.3 Verify `fcs` and `fgb` functions are available and working in a git repository
- [x] 4.4 Verify `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS` is set when git module loads
- [x] 4.5 Verify `core::backup::snapshot` still works with the renamed function

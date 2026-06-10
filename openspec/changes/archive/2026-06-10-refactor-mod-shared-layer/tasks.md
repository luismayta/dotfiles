## 1. Rename directory `zsh/mod/` → `zsh/core/`

- [x] 1.1 Run `git mv zsh/mod zsh/core` to rename the directory
- [x] 1.2 Update `~/.zshrc`: change `DOTFILES_MOD_DIR` to `DOTFILES_CORE_DIR` pointing to `zsh/core`
- [x] 1.3 Update `~/.zshrc`: change source path from `DOTFILES_MOD_DIR/main.zsh` to `DOTFILES_CORE_DIR/main.zsh`
- [x] 1.4 Update all internal `"${DOTFILES_MOD_DIR}"` to `"${DOTFILES_CORE_DIR}"` in new `zsh/core/` files

## 2. Clean up file headers

- [x] 2.1 Remove `#!/usr/bin/env ksh` and `# -*- coding: utf-8 -*-` from all 10 files in `zsh/core/`
- [x] 2.2 Add `# shellcheck shell=bash` directive as first line in all sourced `.zsh` files in `zsh/core/`

## 3. Refactor config layer — split config/base.zsh

- [x] 3.1 Create `zsh/core/config/paths.zsh` with PATH env vars: `DOTFILES_BACKUP_DIR`, `DOTFILES_CACHE_DIR`, `LOCAL_PATH_BIN`, `HOMEBREW_BIN_PATH`, `PRIVATERC`, `CUSTOMRC`, `DOTFILES_BIN` PATH entry, and `LOCAL_PATH_BIN`/`local/bin`/`usr/local/sbin` PATH entries
- [x] 3.2 Create `zsh/core/config/history.zsh` with `HISTFILE`, `HISTSIZE`, `SAVEHIST`
- [x] 3.3 Create `zsh/core/config/language.zsh` with `LANG`, `LC_ALL`
- [x] 3.4 Create `zsh/core/config/autosuggest.zsh` with `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE`, `ZSH_AUTOSUGGEST_USE_ASYNC`
- [x] 3.5 Create `zsh/core/config/git.zsh` with `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS`
- [x] 3.6 Remove `zsh/core/config/base.zsh`

## 4. Refactor config layer — remove factory functions

- [x] 4.1 Rewrite `zsh/core/config/main.zsh` to use direct sourcing chain instead of `dotfiles::config::main::factory` wrapper
- [x] 4.2 Ensure `config/main.zsh` still creates `DOTFILES_BACKUP_DIR` and `DOTFILES_CACHE_DIR` after sourcing

## 5. Refactor internal layer — split internal/base.zsh

- [x] 5.1 Create `zsh/core/internal/path.zsh` with `path::append`, `path::prepend`, `path::clean`
- [x] 5.2 Create `zsh/core/internal/editor.zsh` with `editrc`, `editprivaterc`, `editcustomrc`
- [x] 5.3 Create `zsh/core/internal/backup.zsh` with `backup`
- [x] 5.4 Create `zsh/core/internal/reload.zsh` with `reload`
- [x] 5.5 Remove `zsh/core/internal/base.zsh`

## 6. Refactor internal layer — migrate aliases

- [x] 6.1 Migrate `df`, `free`, `gurl`, `week`, `whois`, `wget` aliases to `zsh/modules/core/pkg/alias.zsh`
- [x] 6.2 Remove `zsh/core/internal/aliases.zsh`

## 7. Refactor internal layer — remove factory functions

- [x] 7.1 Rewrite `zsh/core/internal/main.zsh` to use direct sourcing chain instead of `dotfiles::internal::main::factory` wrapper
- [x] 7.2 Update `internal/main.zsh` to source the new domain files: `path.zsh`, `editor.zsh`, `backup.zsh`, `reload.zsh`, plus OS-specific files

## 8. Verify

- [x] 8.1 Run `git status` to confirm all changes are tracked
- [x] 8.2 Run `task validate` to confirm pre-commit hooks pass
- [ ] 8.3 Source dotfiles in test shell and verify all functions work (`editrc`, `reload`, `path::append`, `backup`, etc.)

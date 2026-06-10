## Design Decision Records

### DR-001: Rename `zsh/mod/` → `zsh/core/`
- **Context**: The name "mod" is ambiguous — it could mean modules, modifications, mod files. It doesn't communicate the role of this directory as the foundational infrastructure for the shell.
- **Decision**: Rename the directory to `zsh/core/` and the environment variable from `DOTFILES_MOD_DIR` to `DOTFILES_CORE_DIR`. Update `~/.zshrc` accordingly.
- **Consequence**: Clean naming; `core` vs `modules` now has clear semantic separation (foundation vs features). Requires a one-time `git mv` and config update.

### DR-002: Direct sourcing chain — no factory functions
- **Context**: `zsh/mod/config/main.zsh` and `zsh/mod/internal/main.zsh` use factory-function wrappers (`dotfiles::config::main::factory`) that add an unnecessary indirection layer. `zsh/modules/core/` uses direct sourcing, which is simpler and more maintainable.
- **Decision**: Replace factory-function wrappers with direct `source` calls at file scope.
- **Consequence**: Simpler code, consistent with module patterns. Current consumers source `main.zsh` which already sources the factory — direct sourcing at the same point is transparent to consumers.

### DR-003: Split monolithic files by domain
- **Context**: `internal/base.zsh` contains four unrelated groups of functions (PATH, editor, backup, reload). `config/base.zsh` mixes path, history, locale, and autosuggest config. This violates single-responsibility and makes it harder to find or refactor individual utilities.
- **Decision**: Split into one file per domain, named after the concern: `path.zsh`, `editor.zsh`, `backup.zsh`, `reload.zsh` for internal; `paths.zsh`, `history.zsh`, `language.zsh`, `autosuggest.zsh`, `git.zsh` for config.
- **Consequence**: Each file has one responsibility. Engineers can find the right file by name. Adding new utilities in a domain means adding to the existing file, not creating a new monolithic section.

### DR-004: Aliases migrate to feature modules
- **Context**: `internal/aliases.zsh` contains general-purpose aliases mixed with git aliases. These are feature concerns, not core infrastructure.
- **Decision**: Migrate general aliases (`df`, `free`, `gurl`, `week`, `whois`) to `zsh/modules/core/pkg/alias.zsh`. Migrate git aliases to `zsh/modules/git/`. Remove `internal/aliases.zsh`.
- **Consequence**: Aliases live in their respective feature modules. The core layer stays focused on infrastructure. No behavioral change — aliases are still loaded at shell start, just from different files.

### DR-005: Remove shebangs from sourced files
- **Context**: All `.zsh` files in `zsh/mod/` have `#!/usr/bin/env ksh` headers, which is misleading (content is ZSH, files are never executed directly, only sourced) and inconsistent with `zsh/modules/core/`.
- **Decision**: Replace `#!/usr/bin/env ksh` (and any `# -*- coding: utf-8 -*-` metadata) with a single `# shellcheck shell=zsh` directive.
- **Consequence**: Accurate file metadata. ShellCheck lints the files correctly. No behavioral change (shebang is ignored when sourcing).

### DR-006: `DOTFILES_BACKUP_DIR` and `DOTFILES_CACHE_DIR` stay in config/main.zsh
- **Context**: These directories depend on `DOTFILES_CONFIG_DIR` which is defined by config sources, but they need to exist before internal files (like `backup.zsh`) use them.
- **Decision**: Keep `mkdir -p` creation of `DOTFILES_BACKUP_DIR` and `DOTFILES_CACHE_DIR` at the end of `config/main.zsh`, after all config sources.
- **Consequence**: Dirs exist before any consumer accesses them. Consistent with current behavior.

## Implementation Flow

```
zsh/core/main.zsh
  ├── config/main.zsh          (direct sourcing, no factory)
  │   ├── config/paths.zsh     (env var exports: DOTFILES_BACKUP_DIR, etc.)
  │   ├── config/history.zsh   (HISTFILE, HISTSIZE, SAVEHIST)
  │   ├── config/language.zsh  (LANG, LC_ALL)
  │   ├── config/autosuggest.zsh (ZSH_AUTOSUGGEST_*)
  │   ├── config/git.zsh       (GIT_INTERNAL_GETTEXT_*)
  │   ├── config/osx.zsh       (OS-specific, unchanged)
  │   └── config/linux.zsh     (Linux-specific, unchanged)
  │
  └── internal/main.zsh        (direct sourcing, no factory)
      ├── internal/path.zsh    (path::append, path::prepend, path::clean)
      ├── internal/editor.zsh  (editrc, editprivaterc, editcustomrc)
      ├── internal/backup.zsh  (backup)
      ├── internal/reload.zsh  (reload)
      ├── internal/osx.zsh     (OS-specific, unchanged)
      └── internal/linux.zsh   (Linux-specific, unchanged)
```

No more `aliases.zsh` — aliases moved to `zsh/modules/core/pkg/alias.zsh` and `zsh/modules/git/`.

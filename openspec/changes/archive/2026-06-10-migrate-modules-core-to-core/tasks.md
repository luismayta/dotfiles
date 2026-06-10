## 1. Prepare target structure

- [x] 1.1 Create `zsh/core/pkg/` directory with subdirectories (helper/)
- [x] 1.2 Verify existing `zsh/core/config/`, `internal/`, and `main.zsh` are in place

## 2. Migrate config layer

- [x] 2.1 Copy `zsh/modules/core/config/base.zsh` to `zsh/core/config/env.zsh`, updating `CORE_PATH` references to resolve correctly
- [x] 2.2 Merge `zsh/modules/core/config/main.zsh` loader chain into `zsh/core/config/main.zsh`, adding `env.zsh` to the sources
- [x] 2.3 Merge `zsh/modules/core/config/osx.zsh` content into `zsh/core/config/osx.zsh`
- [x] 2.4 Merge `zsh/modules/core/config/linux.zsh` content into `zsh/core/config/linux.zsh`

## 3. Migrate internal layer

- [x] 3.1 Copy `zsh/modules/core/internal/base.zsh` to `zsh/core/internal/api.zsh`, updating source paths
- [x] 3.2 Copy `zsh/modules/core/internal/git.zsh` to `zsh/core/internal/git.zsh`, updating source paths
- [x] 3.3 Merge `zsh/modules/core/internal/backup.zsh` content into `zsh/core/internal/backup.zsh`
- [x] 3.4 Merge `zsh/modules/core/internal/main.zsh` loader chain into `zsh/core/internal/main.zsh`, adding `api.zsh` and `git.zsh`
- [x] 3.5 Merge `zsh/modules/core/internal/osx.zsh` content into `zsh/core/internal/osx.zsh`
- [x] 3.6 Merge `zsh/modules/core/internal/linux.zsh` content into `zsh/core/internal/linux.zsh`

## 4. Create pkg/ layer

- [x] 4.1 Copy `zsh/modules/core/pkg/base.zsh` to `zsh/core/pkg/base.zsh`, updating source paths to `CORE_PATH`
- [x] 4.2 Copy `zsh/modules/core/pkg/alias.zsh` to `zsh/core/pkg/alias.zsh`
- [x] 4.3 Copy `zsh/modules/core/pkg/docker.zsh` to `zsh/core/pkg/docker.zsh`
- [x] 4.4 Copy `zsh/modules/core/pkg/osx.zsh` to `zsh/core/pkg/osx.zsh`
- [x] 4.5 Copy `zsh/modules/core/pkg/linux.zsh` to `zsh/core/pkg/linux.zsh`
- [x] 4.6 Copy `zsh/modules/core/pkg/main.zsh` to `zsh/core/pkg/main.zsh`, updating source paths
- [x] 4.7 Copy `zsh/modules/core/pkg/helper/main.zsh` to `zsh/core/pkg/helper/main.zsh`
- [x] 4.8 Copy `zsh/modules/core/pkg/helper/backup.zsh` to `zsh/core/pkg/helper/backup.zsh`
- [x] 4.9 Copy `zsh/modules/core/pkg/helper/core.zsh` to `zsh/core/pkg/helper/core.zsh`

## 5. Update entry point

- [x] 5.1 Update `zsh/core/main.zsh` to add idempotency guard (`[[ -n "${__ZSH_CORE_LOADED:-}" ]] && return`)
- [x] 5.2 Set `CORE_PATH` variable pointing to `zsh/core/` in `main.zsh`
- [x] 5.3 Add config/ → internal/ → pkg/ loader chain to `main.zsh`

## 6. Remove old module

- [x] 6.1 Search repo for any remaining references to `zsh/modules/core/` or `CORE_PATH` pointing to `modules/core`
- [x] 6.2 Delete `zsh/modules/core/` directory
- [x] 6.3 Update `.zshrc` or `.zshrc.d/` to source `zsh/core/main.zsh` instead of `zsh/modules/core/plugin.zsh`

## 7. Verification

- [x] 7.1 Run `task validate` to confirm shellcheck and other hooks pass
- [x] 7.2 Source `zsh/core/main.zsh` in isolation and verify no errors
- [x] 7.3 Verify `core::exists`, `core::install`, `message_info` work correctly
- [x] 7.4 Verify eza aliases (ls, ll, lsa) load and function
- [x] 7.5 Verify FZF helper functions are defined (`fkill`, `fa`, `fgb`, etc.)
- [x] 7.6 Verify Docker wrappers are defined (`awscli`, `ytdl`, `komiser`)
- [x] 7.7 Verify Linux polyfills work on Linux (`open`, `pbcopy`, `pbpaste`)

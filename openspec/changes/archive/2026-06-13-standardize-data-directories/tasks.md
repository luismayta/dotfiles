## 1. ghostty — Migrate conf/ → data/

- [ ] 1.1 `git mv zsh/modules/ghostty/conf/ zsh/modules/ghostty/data/`
- [ ] 1.2 Update `config/base.zsh`: replace `GHOSTTY_CONF_DIR="${GHOSTTY_PATH}/conf"` with `GHOSTTY_DATA_PATH="${GHOSTTY_PATH}/data"` and `GHOSTTY_THEMES_DIR="${GHOSTTY_CONF_DIR}/themes"` with `GHOSTTY_THEMES_DIR="${GHOSTTY_DATA_PATH}/themes"`
- [ ] 1.3 Update `internal/base.zsh`: change rsync source from `${GHOSTTY_CONF_DIR}/` to `${GHOSTTY_DATA_PATH}/`
- [ ] 1.4 Verify with `task validate`

## 2. resources — Migrate assets/fonts/ → data/fonts/

- [ ] 2.1 `mkdir -p zsh/modules/resources/data && git mv zsh/modules/resources/assets/fonts/ zsh/modules/resources/data/fonts/`
- [ ] 2.2 Update `config/base.zsh`: replace `RESOURCES_ASSETS_DIR` with `RESOURCES_DATA_PATH="${RESOURCES_PATH}/data"` and update `RESOURCES_ASSETS_FONTS_DIR` to derive from `RESOURCES_DATA_PATH`
- [ ] 2.3 Update `pkg/base.zsh`: change rsync source from `${RESOURCES_ASSETS_FONTS_DIR}/` to `${RESOURCES_DATA_PATH}/fonts/`
- [ ] 2.4 Verify with `task validate`

## 3. starship — Provision data/ and fix rsync source

- [ ] 3.1 Create `zsh/modules/starship/data/` directory with default `starship.toml`
- [ ] 3.2 Update `config/base.zsh`: add `STARSHIP_DATA_PATH="${ZSH_STARSHIP_PATH}/data"`
- [ ] 3.3 Update `pkg/base.zsh`: change rsync source from `${ZSH_STARSHIP_PATH}/conf/` to `${STARSHIP_DATA_PATH}/`
- [ ] 3.4 Verify with `task validate`

## 4. ssh — Migrate conf/ → data/

- [ ] 4.1 `git mv zsh/modules/ssh/conf/ zsh/modules/ssh/data/`
- [ ] 4.2 Update `config/base.zsh`: replace `SSH_PATH_CONF="${SSH_PATH}/conf"` with `SSH_DATA_PATH="${SSH_PATH}/data"`
- [ ] 4.3 Update `internal/base.zsh`: change rsync source from `${SSH_PATH_CONF}/` to `${SSH_DATA_PATH}/`
- [ ] 4.4 Verify with `task validate`

## 5. git — Migrate sync/ → data/sync/ and template/ → data/hooks/

- [ ] 5.1 `mkdir -p zsh/modules/git/data && git mv zsh/modules/git/sync/ zsh/modules/git/data/sync/` and create `zsh/modules/git/data/hooks/.gitkeep`
- [ ] 5.2 Update `config/base.zsh`: add `GIT_DATA_PATH="${ZSH_GIT_PATH}/data"` and update `ZSH_GIT_HOOKS_PATH="${GIT_DATA_PATH}/hooks/"`
- [ ] 5.3 Update `internal/base.zsh`: change rsync sources — `${ZSH_GIT_PATH}/sync/` to `${GIT_DATA_PATH}/sync/`, `${ZSH_GIT_HOOKS_PATH}/` (already using variable, just update its value)
- [ ] 5.4 Verify with `task validate`

## 6. devops — Migrate conf/k9s/ → data/k9s/

- [ ] 6.1 `mkdir -p zsh/modules/devops/data && git mv zsh/modules/devops/conf/k9s/ zsh/modules/devops/data/k9s/`
- [ ] 6.2 Update `pkg/k9s.zsh`: change rsync source from `${DEVOPS_PATH}/conf/k9s/` to `${DEVOPS_PATH}/data/k9s/` (or add `DEVOPS_DATA_PATH` and use that)
- [ ] 6.3 Verify with `task validate`

## 7. Housekeeping — rsync guards and cleanup

- [ ] 7.1 Add `core::exists rsync` guard to `plugin.zsh` for starship, ssh, and devops (modules lacking any guard)
- [ ] 7.2 Remove orphaned empty directories (e.g., `zsh/modules/resources/assets/` after fonts move)
- [ ] 7.3 Run `task validate` on all modified modules
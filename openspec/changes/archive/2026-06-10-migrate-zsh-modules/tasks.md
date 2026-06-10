## 1. Migrate aliases module

- [ ] 1.1 Create `zsh/modules/aliases/` directory with `config/`, `internal/`, `pkg/` subdirectories
- [ ] 1.2 Copy `config/*.zsh` from `zsh-aliases` repo into `zsh/modules/aliases/config/`; rewrite `config/main.zsh` to use direct sourcing instead of factory function, and use `ALIASES_PATH` instead of `ZSH_ALIASES_PATH`
- [ ] 1.3 Copy `internal/*.zsh` from `zsh-aliases` repo into `zsh/modules/aliases/internal/`; rewrite `internal/main.zsh` to use direct sourcing instead of factory function, and use `ALIASES_PATH` instead of `ZSH_ALIASES_PATH`
- [ ] 1.4 Copy `pkg/*.zsh` from `zsh-aliases` repo into `zsh/modules/aliases/pkg/`; rewrite `pkg/main.zsh` to use direct sourcing instead of factory function, and use `ALIASES_PATH` instead of `ZSH_ALIASES_PATH`
- [ ] 1.5 Copy `core/*.zsh` from `zsh-aliases` repo into `zsh/modules/aliases/internal/` (merge core utilities into internal layer)
- [ ] 1.6 Create `zsh/modules/aliases/plugin.zsh` with idempotency guard, `ALIASES_PATH`, and chain sourcing `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`

## 2. Migrate clean module

- [ ] 2.1 Create `zsh/modules/clean/` directory with `config/`, `internal/`, `pkg/` subdirectories
- [ ] 2.2 Copy `config/*.zsh` from `zsh-clean` repo into `zsh/modules/clean/config/`; rewrite `config/main.zsh` to use direct sourcing and `CLEAN_PATH`
- [ ] 2.3 Copy `internal/*.zsh` from `zsh-clean` repo into `zsh/modules/clean/internal/`; rewrite `internal/main.zsh` to use direct sourcing and `CLEAN_PATH`
- [ ] 2.4 Copy `pkg/*.zsh` from `zsh-clean` repo into `zsh/modules/clean/pkg/`; rewrite `pkg/main.zsh` to use direct sourcing and `CLEAN_PATH`
- [ ] 2.5 Copy `core/*.zsh` from `zsh-clean` repo into `zsh/modules/clean/internal/` (merge core utilities into internal layer)
- [ ] 2.6 Create `zsh/modules/clean/plugin.zsh` with idempotency guard, `CLEAN_PATH`, and chain sourcing

## 3. Migrate pazi module

- [ ] 3.1 Create `zsh/modules/pazi/` directory with `config/`, `internal/`, `pkg/` subdirectories
- [ ] 3.2 Copy `config/*.zsh` from `zsh-pazi` repo into `zsh/modules/pazi/config/`; rewrite `config/main.zsh` to use direct sourcing and `PAZI_PATH`
- [ ] 3.3 Copy `internal/*.zsh` from `zsh-pazi` repo into `zsh/modules/pazi/internal/`; rewrite `internal/main.zsh` to use direct sourcing and `PAZI_PATH`
- [ ] 3.4 Copy `pkg/*.zsh` from `zsh-pazi` repo into `zsh/modules/pazi/pkg/`; rewrite `pkg/main.zsh` to use direct sourcing and `PAZI_PATH`
- [ ] 3.5 Create `zsh/modules/pazi/plugin.zsh` with idempotency guard, `PAZI_PATH`, and chain sourcing

## 4. Migrate devops module

- [ ] 4.1 Create `zsh/modules/devops/` directory with `config/`, `internal/`, `pkg/` subdirectories
- [ ] 4.2 Copy `config/*.zsh` from `zsh-devops` repo into `zsh/modules/devops/config/`; rewrite `config/main.zsh` to use direct sourcing and `DEVOPS_PATH`
- [ ] 4.3 Copy `internal/*.zsh` from `zsh-devops` repo into `zsh/modules/devops/internal/`; rewrite `internal/main.zsh` to use direct sourcing and `DEVOPS_PATH`
- [ ] 4.4 Copy `pkg/*.zsh` from `zsh-devops` repo into `zsh/modules/devops/pkg/`; rewrite `pkg/main.zsh` to use direct sourcing and `DEVOPS_PATH`
- [ ] 4.5 Copy `core/*.zsh` from `zsh-devops` repo into `zsh/modules/devops/internal/` (merge core utilities into internal layer)
- [ ] 4.6 Create `zsh/modules/devops/plugin.zsh` with idempotency guard, `DEVOPS_PATH`, and chain sourcing

## 5. Verify and validate

- [ ] 5.1 Run `git status` to confirm all new files are tracked
- [ ] 5.2 Verify each module directory has the correct structure: `plugin.zsh`, `config/`, `internal/`, `pkg/`
- [ ] 5.3 Verify no existing module files were modified
- [ ] 5.4 Source dotfiles in a test shell to confirm modules load without errors
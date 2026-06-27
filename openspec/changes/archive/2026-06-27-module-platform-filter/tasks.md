## 1. Reference Module — hyprland (Linux-only)

- [x] 1.1 Añadir `ZSH_HYPRLAND_ENABLED="${ZSH_HYPRLAND_ENABLED:-true}"` en `zsh/modules/hyprland/config/base.zsh`
- [x] 1.2 Añadir `ZSH_HYPRLAND_ENABLED=false` en `zsh/modules/hyprland/config/osx.zsh`
- [x] 1.3 Añadir guard `$ZSH_HYPRLAND_ENABLED || return` en `zsh/modules/hyprland/plugin.zsh` después de `source config/main.zsh`

## 2. Cross-platform modules (29 modules) — base.zsh + guard

- [x] 2.1 Añadir `ZSH_AI_ENABLED="${ZSH_AI_ENABLED:-true}"` en `zsh/modules/ai/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.2 Añadir `ZSH_ALACRITTY_ENABLED` en `zsh/modules/alacritty/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.3 Añadir `ZSH_ALIASES_ENABLED` en `zsh/modules/aliases/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.4 Añadir `ZSH_APPS_ENABLED` en `zsh/modules/apps/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.5 Añadir `ZSH_BITWARDEN_ENABLED` en `zsh/modules/bitwarden/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.6 Añadir `ZSH_CLEAN_ENABLED` en `zsh/modules/clean/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.7 Añadir `ZSH_DEVBOX_ENABLED` en `zsh/modules/devbox/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.8 Añadir `ZSH_DEVOPS_ENABLED` en `zsh/modules/devops/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.9 Añadir `ZSH_DOCKER_ENABLED` en `zsh/modules/docker/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.10 Añadir `ZSH_FNM_ENABLED` en `zsh/modules/fnm/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.11 Añadir `ZSH_GHOSTTY_ENABLED` en `zsh/modules/ghostty/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.12 Añadir `ZSH_GHQ_ENABLED` en `zsh/modules/ghq/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.13 Añadir `ZSH_GIT_ENABLED` en `zsh/modules/git/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.14 Añadir `ZSH_GOENV_ENABLED` en `zsh/modules/goenv/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.15 Añadir `ZSH_ISSUES_ENABLED` en `zsh/modules/issues/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.16 Añadir `ZSH_NIX_ENABLED` en `zsh/modules/nix/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.17 Añadir `ZSH_NOTIFY_ENABLED` en `zsh/modules/notify/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.18 Añadir `ZSH_NVIM_ENABLED` en `zsh/modules/nvim/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.19 Añadir `ZSH_PAZI_ENABLED` en `zsh/modules/pazi/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.20 Añadir `ZSH_PYENV_ENABLED` en `zsh/modules/pyenv/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.21 Añadir `ZSH_RESOURCES_ENABLED` en `zsh/modules/resources/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.22 Añadir `ZSH_RUST_ENABLED` en `zsh/modules/rust/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.23 Añadir `ZSH_RVM_ENABLED` en `zsh/modules/rvm/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.24 Añadir `ZSH_SCMBREEZE_ENABLED` en `zsh/modules/scmbreeze/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.25 Añadir `ZSH_SSH_ENABLED` en `zsh/modules/ssh/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.26 Añadir `ZSH_STARSHIP_ENABLED` en `zsh/modules/starship/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.27 Añadir `ZSH_TEMPLATES_ENABLED` en `zsh/modules/templates/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.28 Añadir `ZSH_TMUX_ENABLED` en `zsh/modules/tmux/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.29 Añadir `ZSH_WEZTERM_ENABLED` en `zsh/modules/wezterm/config/base.zsh` + guard en `plugin.zsh`
- [x] 2.30 Añadir `ZSH_ZED_ENABLED` en `zsh/modules/zed/config/base.zsh` + guard en `plugin.zsh`

## 3. Documentation

- [x] 3.1 Actualizar `zsh/modules/README.md` con el patrón `ZSH_<MODULE>_ENABLED` y ejemplos

## 4. Verification

- [x] 4.1 Sourcear `zsh/zshrc` en macOS y confirmar que hyprland no se carga (sin `message_info`)
- [x] 4.2 Confirmar que todos los cross-platform modules cargan normalmente
- [x] 4.3 Test override: `export ZSH_HYPRLAND_ENABLED=true` en `~/.customrc` y confirmar que hyprland carga en macOS
- [x] 4.4 Test override: `export ZSH_GIT_ENABLED=false` en `~/.customrc` y confirmar que git no carga

## 1. Sync Plan

- [ ] 1.1 Create `zsh/core/pkg/sync.zsh`: define `DOTFILES_SYNC_PLAN` array con lista ordenada de syncs (ghostty, alacritty, wezterm, zed, starship, tmux, git, ssh, nvim, opencode, fabric, k9s, komiser, hyprland, fonts, devbox)

## 2. Core Function

- [ ] 2.1 Implement `dotfiles::sync` en `zsh/core/pkg/sync.zsh`:
  - Iterar `DOTFILES_SYNC_PLAN` en orden
  - Check `ZSH_<MODULE>_ENABLED` antes de cada sync; skip si disabled
  - Ejecutar cada sync con captura de error (subshell o `||`)
  - Live progress: `→ [N/16] <name>... ✓/✗/-`
  - Resumen final agrupado por categoría con contadores

## 3. Integración en Core

- [ ] 3.1 Añadir `source "${DOTFILES_CORE_PATH}"/pkg/sync.zsh` a `zsh/core/pkg/main.zsh`
- [ ] 3.2 Verificar `dotfiles::sync` se ejecuta sin errores
- [ ] 3.3 Verificar módulos deshabilitados se saltan correctamente
- [ ] 3.4 Verificar resumen muestra contadores correctos

## 1. Shell: Configurar ripgrep con --hidden por defecto

- [x] 1.1 Crear `zsh/core/config/ripgreprc` con `--hidden` y exclusión de `.git/`
- [x] 1.2 Exportar `RIPGREP_CONFIG_PATH` en `zsh/core/config/env.zsh` apuntando al archivo creado
- [ ] 1.3 Verificar: `rg .` en un directorio con dotfiles los incluye en resultados

## 2. Shell: Agregar --hidden explícito en helper fgr

- [ ] 2.1 Modificar `zsh/core/pkg/helper/core.zsh` — comando `fgr`: agregar `--hidden` al flag de `rg`
- [ ] 2.2 Verificar que `fgr` muestre resultados de archivos como `.pre-commit-config.yaml`

## 3. Neovim: Configurar Telescope para archivos ocultos

- [x] 3.1 Agregar `hidden = true` y `no_ignore = true` en `defaults` de Telescope en `zsh/modules/nvim/data/lua/plugins/spec/ui/ui.lua`
- [x] 3.2 Agregar `vimgrep_arguments` con `--hidden` en los defaults de Telescope
- [ ] 3.3 Verificar que `<leader>ff` muestre `.pre-commit-config.yaml`
- [ ] 3.4 Verificar que `<leader>fg` busque texto dentro de dotfiles

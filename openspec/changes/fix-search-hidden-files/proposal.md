## Why

Los dotfiles en el proyecto (`.pre-commit-config.yaml`, `.stylua.toml`, etc.) no aparecen en búsquedas con `rg`, `fd` ni en Telescope (Neovim) porque estas herramientas ignoran archivos ocultos por defecto. Esto causa que:
- Archivos importantes del proyecto sean invisibles al buscar
- Helpers de fzf como `fgr` (grep via rg) omitan contenido de dotfiles
- Telescope no muestre dotfiles ni con `<leader>ff` ni con `<leader>fg`

## What Changes

- Configurar `ripgrep` para incluir archivos ocultos por defecto vía `RIPGREP_CONFIG_PATH`
- Agregar `--hidden` a los helpers de fzf que lo omiten (principalmente `fgr`)
- Configurar Telescope (Neovim) para mostrar archivos ocultos en todos sus pickers (`defaults`) y en `live_grep` (`vimgrep_arguments`)
- No modificar el comportamiento de git (git trackea correctamente los archivos)

## Capabilities

### New Capabilities
- `ripgrep-hidden-default`: Configurar ripgrep para incluir archivos ocultos por defecto mediante `RIPGREP_CONFIG_PATH`
- `fzf-helpers-hidden-consistency`: Unificar el flag `--hidden` en todos los helpers de fzf que usen `rg`/`fd`, comenzando con `fgr`
- `telescope-hidden-files`: Configurar Telescope para mostrar archivos ocultos en todos los pickers (`defaults`) y en `live_grep` (`vimgrep_arguments`)

### Modified Capabilities
<!-- No existing specs are being modified -->

## Impact

- `zsh/core/config/`: crear `ripgreprc` — archivo de config para rg
- `zsh/core/config/env.zsh`: exportar `RIPGREP_CONFIG_PATH`
- `zsh/core/pkg/helper/core.zsh`: helper `fgr` — agregar `--hidden`
- `zsh/modules/nvim/data/lua/plugins/spec/ui/ui.lua`: agregar `hidden`, `no_ignore` en `defaults` y `--hidden` en `vimgrep_arguments`
- No afecta el flujo de git

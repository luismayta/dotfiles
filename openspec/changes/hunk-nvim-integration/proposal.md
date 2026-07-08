## Why

Hunk (`github.com/modem-dev/hunk`) es un TUI diff viewer interactivo con modo daemon para AI agents, ideal para revisiones de código en terminal. Actualmente está integrado solo en el módulo `ai` (wrapper functions, aliases, config template y OpenCode command). El flujo de trabajo de diff review está fragmentado: desde Neovim no hay una forma directa de lanzar hunk sobre el working tree o un commit. Integrar hunk en el módulo `nvim` permite al usuario inspeccionar cambios de forma interactiva sin salir del ecosistema Neovim, con soporte para agentes AI.

## What Changes

- **Nuevo plugin spec Neovim** en `nvim/data/lua/plugins/tools/hunk.lua` que registra hunk como una tool de diff review desde Neovim
- **Keymaps** para lanzar hunk diff/show desde Neovim (e.g., `<leader>hd` para `hunk diff`, `<leader>hs` para `hunk show`)
- **Comando `:Hunk`** en Neovim que ejecuta hunk en una terminal flotante o en un toggleterm
- **Integración con Telescope** (opcional): selector de hunks/archivos desde Telescope
- **Documentación** en el plugin spec sobre cómo usar hunk con y sin agentes AI
- **No BREAKING**: no se modifica ni elimina ninguna funcionalidad existente

## Capabilities

### New Capabilities
- `hunk-diff-review`: Lanzar `hunk diff` sobre el working tree desde Neovim en una terminal flotante, con keymaps dedicados
- `hunk-commit-view`: Lanzar `hunk show` para inspeccionar commits específicos desde Neovim
- `hunk-daemon`: Iniciar/detener el daemon de hunk desde Neovim para sesiones con AI agents

### Modified Capabilities
<!-- No existing specs are being modified -->

## Impact

- **Archivos nuevos**: `zsh/modules/nvim/data/lua/plugins/tools/hunk.lua`
- **Dependencias**: requiere tener hunk instalado (vía npm, ya gestionado por el módulo `ai`)
- **Sin cambios en módulos existentes**: la integración es aditiva, no modifica plugin specs existentes ni el entry point de nvim
- **Sin breaking changes**: diffview.nvim, gitsigns, neogit y fugitive siguen funcionando igual

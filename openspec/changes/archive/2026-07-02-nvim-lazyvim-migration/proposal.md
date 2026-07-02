## Why

La configuración actual de Neovim está basada en NvChad v2.5 con un sistema de build manual (`auto-import.lua` + `task build`) que lazy.nvim ya resuelve automáticamente. Mantenemos ~70 archivos de configuración, 12+ plugins de UI de dudosa utilidad activa, y 6 plugins deshabilitados que solo añaden ruido. No versionamos las versiones de plugins (`lazy-lock.json`), lo que hace que la configuración no sea reproducible entre máquinas. El framework NvChad tiene mantenimiento mínimos mientras que LazyVim tiene社区 activa y extras oficiales que cubren la mayoría de nuestras necesidades. Migrar a LazyVim reduce ~70 archivos a ~15, elimina el build step, y mejora la mantenibilidad a largo plazo.

## What Changes

- **Migrar de NvChad v2.5 a LazyVim** como framework base de Neovim
- **Eliminar `scripts/auto-import.lua`** y el build step asociado en Taskfile.yml
- **Reemplazar `plugins/init.lua` auto-generado** por import estático
- **Crear `lazy-lock.json`** para versionar plugins y asegurar reproducibilidad
- **Migrar plugins custom** (codeium, codesnap, goto-preview, scrolleof, matchup, regexplainer, searchbox, fine-cmdline, focus.nvim, b64, ccc, etc.) a archivos planos de lazy.nvim
- **Eliminar 9 plugins muertos o de baja utilidad**: avante, codecompanion, neocomposer, auto-session, dressing, nvim-colorizer, screenkey, tabby-ml, dropbar
- **Migrar capa `lua/jasper/`** (keymaps, lsp, telescope, autocmds, utils) a `lua/config/`
- **Eliminar directorios**: `lua/configs/`, `lua/plugins/spec/`, `lua/plugins/override/`
- **Cambiar leader key** de `,` a `<Space>` (estándar LazyVim)
- **Adoptar LazyVim extras** para: harpoon2, grug-far, edgy, diffview, neogit, undotree, trouble, mason, terraform, docker, helm, python, rust, typescript, go, markdown, yaml, json, mini-surround, dap.core, neoconf

## Capabilities

### New Capabilities
- `lazyvim-bootstrap`: Configuración base de LazyVim (init.lua, lazy.lua, options.lua, keymaps.lua, autocmds.lua)
- `lazyvim-extras`: Declaración de extras de LazyVim (harpoon2, grug-far, edgy, diffview, neogit, undotree, trouble, lang support, etc.)
- `plugin-ai`: Plugins de IA (codeium.nvim, codesnap.nvim)
- `plugin-editor`: Plugins de editor (matchup, regexplainer, searchbox, fine-cmdline, focus.nvim, b64, scroll-eof)
- `plugin-ui`: Plugins de UI (ccc.nvim, goto-preview)
- `plugin-telescope`: Configuración personalizada de telescope
- `plugin-colorscheme`: Tema catppuccin para LazyVim

### Modified Capabilities
- *(ninguna — todos los specs existentes serán reemplazados)*

## Impact

- **BREAKING**: Leader key cambia de `,` a `<Space>` — requiere ajuste de muscle memory (~1-2 semanas)
- **BREAKING**: Se eliminan ~55 archivos de configuración existentes
- **BREAKING**: Se elimina `task build` del flujo de trabajo nvim
- **Ningún cambio en plugins externos**: LSP servers, formatters, linters se mantienen vía mason
- **Ningún cambio en el módulo zsh**: `zsh/modules/nvim/` se mantiene intacto (solo apunta a la nueva config)
- **Dependencias**: lazy.nvim ya está presente como plugin manager

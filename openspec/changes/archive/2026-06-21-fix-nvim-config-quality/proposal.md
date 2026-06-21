## Why

La configuración Lua del módulo nvim (NvChad v2.5) contiene 27 hallazgos de calidad identificados en una auditoría: 6 bugs críticos que dejan opciones sin aplicar, causan crashes en TypeScript, duplican configuraciones de LSP, y crean mappings que no funcionan. Además hay deprecaciones (null-ls, tsserver, typescript.nvim), configuraciones huérfanas, y sistemas de formatting triplicados. Sin estos fixes la experiencia de desarrollo en Neovim es inconsistente y frágil.

## What Changes

- **Descomentar y activar** el loop de aplicación de opciones en `options.lua` (encoding, clipboard, folds, indentation, etc.)
- **Corregir** `tsserver`: eliminar de la lista genérica de LSP servers, dejar solo el bloque dedicado
- **Corregir** `typescript.lua`: agregar `nvlsp` y `on_attach` al scope, unificar `on_attach` duplicado
- **Eliminar** mapping duplicado de `<leader>j` y corregir `<leader>j`/`<leader>J` conflictivo
- **Migrar** `null-ls` → `none-ls` o eliminar en favor de conform.nvim
- **Migrar** `tsserver` → `ts_ls` en todos los archivos
- **Unificar** LSP servers: elegir entre `mason-lspconfig` o configuración manual, eliminar duplicación
- **Consolidar** formatting en conform.nvim y eliminar null-ls/none-ls para formato
- **Limpiar** archivos de configuración huérfanos (hop, illuminate, neoscroll, tabout, etc.)
- **Corregir** `M.mason.pkgs` → `M.mason.ensure_installed` en chadrc.lua
- **Actualizar** API de Trouble a v3
- **Eliminar** código comentado y variables no usadas (`nomap` en mappings.lua)
- **Limpiar** specs de plugins deshabilitados o decidir su activación (dankcolors, avante, codecompanion)

## Capabilities

### New Capabilities
- `nvim-core-options`: Corrección de opciones base de Neovim (options.lua) que actualmente no se aplican
- `nvim-lsp-servers`: Unificación y corrección de la configuración de servidores LSP (eliminar duplicación, migrar deprecaciones)
- `nvim-keybindings`: Corrección de mappings duplicados y conflictivos
- `nvim-formatting`: Consolidación del sistema de formatting en conform.nvim
- `nvim-mason-setup`: Corrección de la configuración de Mason (ensure_installed)
- `nvim-plugin-cleanup`: Limpieza de plugins huérfanos, código muerto y deprecaciones

### Modified Capabilities
<!-- None - no existing specs to modify -->

## Impact

- **Archivos afectados**: ~20 archivos .lua en `zsh/modules/nvim/data/lua/`
- **Plugins**: null-ls/none-ls parcialmente reemplazados por conform.nvim
- **APIs**: `tsserver` → `ts_ls`, Trouble v2 → v3, `require("core.utils")` → lazy patterns
- **Riesgo**: Al activar options.lua, cambios visibles en comportamiento de folds, scroll, indentación. Los usuarios pueden necesitar ajustar preferencias personales.
- **Sin cambios**: La estructura del módulo zsh (config/, internal/, pkg/, plugin.zsh) no se modifica, solo data/lua/

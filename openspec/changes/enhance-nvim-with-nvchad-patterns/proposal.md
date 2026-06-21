## Why

El módulo `zsh/modules/nvim/` contiene una configuración NvChad v2.5 con ~80 plugins, pero carece de una capa de utilidades y patrones reutilizables que otros proyectos (como `nvchad-config` de Gaston) ya han resuelto bien. Esto provoca duplicación de lógica en los specs de plugins, configuraciones LSP verbosas, y keymaps inconsistentes. Al adoptar los patrones probados de `nvchad-config`, reducimos deuda técnica y hacemos la configuración más mantenible.

## What Changes

- **Nueva capa `lua/gale/`** (o nombre local: `lua/jasper/`): módulo de utilidades con funciones helper, keymap wrapper, y generadores de configuración reutilizables
- **Keymap wrapper**: función `map()` o similar que unifica definición de keymaps con descripciones, modo, y opciones
- **`on_attach` componible**: generador de `on_attach` para LSP que permite componer funcionalidades (formateo, keymaps, hover, diagnostics) como bloques
- **Telescope picker factory**: layout configs reutilizables para diferentes tipos de búsqueda
- **Auto-import script**: generación automatizada del archivo `plugins/init.lua` a partir de los directorios de specs
- **Utilidades**: funciones genéricas (debounce, combine_lists, word count, etc.)
- **Backup direction sync**: comando `nvim::backup` para sincronizar desde `~/.config/nvim/` hacia `data/`

## Capabilities

### New Capabilities
- `nvim-utils-layer`: Capa de utilidades Lua (`lua/jasper/`) con helpers, keymap wrapper, y funciones de propósito general
- `composable-lsp`: Sistema de `on_attach` componible para configurar LSP servers con bloques reutilizables
- `telescope-picker-factory`: Layout configs reutilizables para Telescope pickers con diferentes modos de visualización
- `plugin-import-autogen`: Script para auto-generar `plugins/init.lua` escaneando los directorios de specs
- `nvim-backup-sync`: Comando shell `nvim::backup` para sincronizar desde `~/.config/nvim/` → `data/`

### Modified Capabilities
<!-- No existing specs to modify -->

## Impact

- **`zsh/modules/nvim/data/lua/`**: nuevos directorios `jasper/` (utils), posible reestructuración de `plugins/init.lua`
- **`zsh/modules/nvim/`**: nuevos comandos `nvim::backup`, extensión de `Taskfile.yml`
- **`nvchad-config`**: repositorio externo de referencia (sin cambios directos)
- **Dependencias**: solo Lua (ya incluido en Neovim), sin nuevas dependencias externas

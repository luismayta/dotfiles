## Why

Actualmente los plugins de nvim tienen una mezcla de archivos organizados en directorios por categoría (`ai/`, `dap/`, `lang/`, `navigation/`, `text/`, `tools/`, `ui/`) junto con archivos sueltos en la raíz de `plugins/`. Esta inconsistencia hace que sea más difícil localizar y mantener las configuraciones de plugins relacionadas. Reorganizar los archivos sueltos dentro de sus categorías correspondientes unifica la estructura y hace que el código sea más predecible.

## What Changes

- Mover `catppuccin.lua` → `ui/catppuccin.lua` (colorscheme — UI/visual)
- Mover `dankcolors.lua` → `ui/dankcolors.lua` (colorscheme — UI/visual)
- Mover `conform.lua` → `tools/conform.lua` (formateo — herramienta)
- Mover `completion.lua` → `tools/completion.lua` (autocompletado — herramienta)
- Mover `luasnip.lua` → `tools/luasnip.lua` (snippets — herramienta)
- Mover `neo-tree.lua` → `navigation/neo-tree.lua` (explorador de archivos — navegación)
- Actualizar `init.lua` con los nuevos paths de import
- Actualizar la ruta de auto-referencia en `dankcolors.lua` (línea 79)
- Limpiar los archivos originales después de moverlos

## Capabilities

### New Capabilities

No se introducen nuevas capacidades. Es una reorganización estructural pura.

### Modified Capabilities

Ninguna — el comportamiento de cada plugin no cambia, solo su ubicación en el árbol de directorios.

## Impact

- **6 archivos movidos** de `zsh/modules/nvim/data/lua/plugins/` raíz a subdirectorios por categoría
- **1 archivo** (`init.lua`) modificado con imports actualizados
- **1 archivo** (`dankcolors.lua`) modificado internamente para reflejar su nueva ruta de auto-referencia
- **Sin cambios en tiempo de ejecución** — lazy.nvim resuelve los imports por módulo, no por ubicación en disco
- Las rutas absolutas de auto-referencia (dankcolors) se actualizan para mantener la funcionalidad de hot-reload

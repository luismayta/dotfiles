## Why

El plugin `render-markdown.nvim` (dependencia de avante.nvim, actualmente deshabilitado) se carga al abrir archivos markdown con su configuración por defecto, que es demasiado invasiva: renders checkboxes, pinta cabeceras con fondo completo, agrega signos en la columna de signos, enlaces con íconos grandes, etc. Esto sobrecarga la edición con exceso de información visual y warnings, dificultando la escritura fluida. El plugin es útil pero necesita una configuración más limpia y minimalista.

Adicionalmente, las combinaciones `<leader>e` y `<leader>fe` de neotree están duplicadas: ambas abren el explorador en la raíz del proyecto, cuando `<leader>e` debería abrir en el directorio del archivo actual.

## What Changes

1. **Reconfigurar `render-markdown.nvim`** con opciones más limpias: sin signos en cabeceras, ancho de cabeceras tipo "block" en lugar de "full", posición inline en lugar de overlay, y deshabilitar rendering de enlaces.
2. **Extraer `render-markdown.nvim`** de las dependencias de avante.nvim (plugin deshabilitado) y declararlo como plugin independiente con su propia configuración.
3. **Corregir `<leader>e`**: cambiar de remap (`<leader>fe`) a una función que abra neotree en el directorio del archivo actual (`vim.fn.expand("%:p:h")`).
4. **Mantener `<leader>fe`** tal como está: abriendo neotree en `LazyVim.root()`.

## Capabilities

### New Capabilities
- `markdown-editing`: Edición limpia de archivos markdown con rendering visual útil pero no invasivo.

### Modified Capabilities
- (ninguno — son cambios de configuración, no de requerimientos de specs existentes)

## Impact

- **Archivos afectados:**
  - `zsh/modules/nvim/data/lua/plugins/ai/ai.lua` — remover dependencia de `render-markdown.nvim`
  - `zsh/modules/nvim/data/lua/plugins/text/render-markdown.lua` — **nuevo archivo** con configuración limpia
  - `zsh/modules/nvim/data/lua/plugins/navigation/neo-tree.lua` — cambiar keybinding `<leader>e`
- **Dependencias:** `render-markdown.nvim` se mantiene instalado, ahora con configuración explícita.
- **Sistema:** Solo configuración de neovim, sin impacto en otros módulos.

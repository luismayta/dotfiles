## Context

Actualmente `zsh/modules/nvim/data/lua/plugins/` tiene 8 directorios por categoría y 6 archivos sueltos en la raíz. Los archivos categorizados siguen el patrón `plugins/<categoria>/<plugin>.lua`, mientras que los sueltos están en `plugins/<plugin>.lua`. LazyVim resuelve los imports por nombre de módulo Lua (punto-notación), no por ubicación física, por lo que mover los archivos es seguro — solo requiere actualizar los imports en `init.lua`.

La estructura destino consiste en 3 categorías existentes + 1 actualización de ruta interna:

| Categoría destino | Archivos a mover |
|---|---|
| `ui/` | `catppuccin.lua`, `dankcolors.lua` (colorschemes) |
| `tools/` | `completion.lua`, `conform.lua`, `luasnip.lua` (snippets, formatter, cmp) |
| `navigation/` | `neo-tree.lua` (file explorer) |

## Goals / Non-Goals

**Goals:**
- Unificar todos los plugins dentro de su categoría correspondiente — cero archivos `.lua` sueltos en la raíz de `plugins/`
- Mantener 100% el comportamiento en tiempo de ejecución de cada plugin
- Preservar la funcionalidad de hot-reload de `dankcolors.lua` (que usa una ruta absoluta a sí mismo)

**Non-Goals:**
- No cambiar la configuración, opts, ni lógica de ningún plugin
- No introducir nuevas categorías — solo reubicar en las existentes
- No cambiar el orden de carga de los plugins

## Decisions

1. **`conform.lua` → `tools/` en lugar de `lsp/`**
   - Conform es un formateador genérico no ligado exclusivamente a LSP. Además, `tools/` ya alberga herramientas de edición (comment, diffview, git, etc.) y es más consistente.

2. **`completion.lua` + `luasnip.lua` → `tools/`**
   - nvim-cmp y LuaSnip son herramientas de edición (autocompletado y snippets). No existe categoría `completion/` ni `snippets/`, y colocarlos juntos en `tools/` mantiene la coherencia con el resto.

3. **`neo-tree.lua` → `navigation/`**
   - neo-tree es un explorador de archivos — un plugin de navegación. `navigation/` ya contiene goto-preview, harpoon, hop, etc. Es la categoría natural.

4. **`catppuccin.lua` + `dankcolors.lua` → `ui/`**
   - Ambos son colorschemes — pertenecen a UI. `ui/` ya contiene todos los plugins visuales.

5. **Actualización de ruta en `dankcolors.lua`**
   - La línea 79 contiene `vim.fn.stdpath "config" .. "/lua/plugins/dankcolors.lua"` usada para el watcher de hot-reload. Debe actualizarse a `"/lua/plugins/ui/dankcolors.lua"` para que el file-watcher siga funcionando.

6. **`catppuccin.lua` se agrega a `init.lua`**
   - Actualmente `catppuccin.lua` existe pero no está importado en `init.lua`. Al moverlo a `ui/`, se agrega su import explícito: `{ import = "plugins.ui.catppuccin" }`.

## Risks / Trade-offs

- **Ruta hardcodeada en dankcolors** → La línea 79 usa `stdpath "config" .. "/lua/plugins/dankcolors.lua"`. Si no se actualiza, el hot-reload deja de funcionar. El fix es trivial (cambiar el path).
- **Riesgo de olvidar import** → Si un archivo se mueve pero su import en `init.lua` no se actualiza, el plugin deja de cargarse. Se mitiga con una checklist en tasks.md que empareje cada archivo movido con su import actualizado.
- **git mv vs cp + rm** → Usar `git mv` para que git preserve el historial del archivo y no lo vea como delete+create.

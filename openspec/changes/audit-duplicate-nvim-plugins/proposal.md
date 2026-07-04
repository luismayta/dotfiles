## Why

La reorganización de plugins en `had/HAD-61` dejó una estructura limpia por categorías, pero expuso duplicaciones: plugins declarados como spec standalone Y como dependencia inline de otros specs. Aunque lazy.nvim mergea specs del mismo `org/repo`, tener la declaración duplicada en múltiples archivos crea ambigüedad sobre dónde vive la configuración "real" y confunde auditorías futuras.

Este change consolida cada plugin en UNA sola ubicación (la categoría que le corresponde) y referencias desde otras categorías como meras dependencias, sin redeclarar el spec completo.

## What Changes

1. **Consolidar `telescope.nvim`** — Declarado como standalone en `ui/ui.lua` y como dependencia en `tools/neogit.lua` y `ai/ai.lua`. Mantener solo en `ui/ui.lua` (ahí vive su config). `neogit` y `ai` lo referencian solo como dep string, no como spec.

2. **Consolidar `nvim-web-devicons`** — Standalone en `ui/ui.lua` y dep en `ai/ai.lua`. Se queda en `ui/ui.lua`.

3. **Consolidar `diffview.nvim`** — Standalone en `tools/diffview.lua` (con keymaps) y dep en `tools/git.lua` + `tools/neogit.lua`. Se queda en `tools/diffview.lua`. `git` y `neogit` lo referencian solo como dep.

4. **Refactorizar `tools/completion.lua`** — El archivo redeclara `hrsh7th/nvim-cmp` y sus sources, que ya vienen con LazyVim core. Separar `ray-x/cmp-treesitter` a su propio spec y eliminar el resto.

5. **Agregar comentarios cross-categoría** — Indicar en los specs principales qué otras categorías los usan como dependencia.

## Capabilities

### New Capabilities
- `plugin-consolidation`: Consolidar declaraciones duplicadas de plugins, moviendo cada spec a su categoría correcta y eliminando redeclaraciones redundantes.

### Modified Capabilities
- `plugin-editor`: Refactorizar `tools/completion.lua` para no redeclarar plugins de LazyVim core.

## Impact

- `ui/ui.lua`: Telescope y devicons se quedan aquí (son UI).
- `tools/diffview.lua`: Diffview se queda aquí (es herramienta git).
- `tools/git.lua`, `tools/neogit.lua`: Diffview como dep string, no como spec.
- `tools/completion.lua`: Se elimina; `cmp-treesitter` se mueve a spec propio.
- `ai/ai.lua`: Telescope y devicons como dep string, no como spec.
- No se eliminan plugins deshabilitados (dressing, avante, codecompanion, neo-tree).
- `codi doctor --llm`: debe seguir en 0 issues.

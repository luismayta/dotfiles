## Context

Tras la reorganización de plugins por categorías (had/HAD-61), varios plugins quedaron declarados en MÚLTIPLES archivos: como spec standalone en su categoría Y como dependencia inline en specs de otras categorías. Aunque lazy.nvim mergea specs del mismo `org/repo` sin problemas, esta duplicación de declaración crea ambigüedad sobre dónde está la configuración real y puede confundir auditorías futuras.

Este change **no elimina plugins ni cambia comportamiento**. Solo consolida cada declaración duplicada en UNA ubicación —la categoría que le corresponde— y deja en las otras categorías solo la referencia como dep string.

## Goals / Non-Goals

**Goals:**
1. Consolidar cada plugin `org/repo` declarado en múltiples archivos → una sola ubicación.
2. Mover la declaración duplicada a la categoría correcta.
3. Refactorizar `tools/completion.lua` para no redeclarar plugins de LazyVim core.
4. Agregar comentarios cross-categoría para rastreabilidad.
5. `codi doctor --llm` debe reportar 0 issues tras los cambios.

**Non-Goals:**
- Eliminar plugins deshabilitados (dressing, avante, codecompanion, neo-tree, etc.).
- Modificar LazyVim core overlays intencionales (gitsigns, which-key, todo-comments, etc.).
- Cambiar keymaps, opts, o comportamiento existente.
- Refactorizar plugins funcionales que ya están bien ubicados.

## Decisions

### D1: `telescope.nvim` se queda en `ui/ui.lua`; se elimina como dep inline de otras categorías

**Estado actual:**
- Standalone en `ui/ui.lua:106-169` (con opts + keymaps)
- Dep inline de `tools/neogit.lua:7` (`"nvim-telescope/telescope.nvim"`)
- Dep inline de `ai/ai.lua:56,92` (`"nvim-telescope/telescope.nvim"`)

**Acción:** Telescope es un componente de UI (pickers, paletas). Su spec completo vive en `ui/ui.lua`. En `neogit.lua` y `ai/ai.lua`, cambiar de `"nvim-telescope/telescope.nvim"` como spec inline a solo comentario indicando dependencia.

**Razón:** El spec completo con opts/keymaps debe estar en un solo lugar para mantener una fuente única de verdad.

### D2: `nvim-web-devicons` se queda en `ui/ui.lua`; se elimina como dep inline de `ai/ai.lua`

**Estado actual:**
- Standalone en `ui/ui.lua:86-103` (con opts override)
- Dep inline de `ai/ai.lua:59` (`"nvim-tree/nvim-web-devicons"`)

**Acción:** Devicons es UI (iconos en la interfaz). El spec completo está en `ui/ui.lua`. En `ai/ai.lua`, cambiar de spec inline a comentario de dependencia.

### D3: `diffview.nvim` se queda en `tools/diffview.lua`; se elimina como dep inline de `tools/git.lua` y `tools/neogit.lua`

**Estado actual:**
- Standalone en `tools/diffview.lua:2-10` (con cmd + keymaps)
- Dep inline de `tools/git.lua:5` (`dependencies = "sindrets/diffview.nvim"`)
- Dep inline de `tools/neogit.lua:6` (`dependencies = { ..., "sindrets/diffview.nvim", ... }`)

**Acción:** Diffview es una herramienta git. Su spec completo (con lazy-loading por `cmd` y keymaps) está en `tools/diffview.lua`. En `git.lua` y `neogit.lua`, el `dependencies` ya es suficiente como string. No necesita ser spec.

### D4: `tools/completion.lua` es redundante con LazyVim core

LazyVim core ya declara `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `saadparwaiz1/cmp_luasnip`, `hrsh7th/cmp-nvim-lsp`, `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`. El único añadido real del archivo `tools/completion.lua` es `ray-x/cmp-treesitter`.

**Acción:** Crear `tools/cmp-treesitter.lua` con el spec de `ray-x/cmp-treesitter`. Eliminar `tools/completion.lua`.

**Razón:** No redeclarar lo que LazyVim core ya provee. Si en el futuro se necesita overridear `nvim-cmp`, se crea un delta spec con comentario explícito.

### D5: Agregar comentarios de dependencia cross-categoría

**Problema:** Si alguien elimina o mueve un spec sin saber que otras categorías lo usan como dependencia, se rompe funcionalidad.

**Acción:** Agregar comentarios al inicio de los specs principales indicando qué archivos los referencian como dependencia.

| Spec | Comentario |
|---|---|
| `ui/ui.lua` (telescope) | `-- Dep of: ai/ai.lua, tools/neogit.lua` |
| `ui/ui.lua` (treesitter) | `-- Dep of: ai/ai.lua, lang/go.lua, text/regexplainer.lua, text/ts-autotag.lua` |
| `ui/ui.lua` (devicons) | `-- Dep of: ai/ai.lua` |
| `tools/diffview.lua` | `-- Dep of: tools/git.lua, tools/neogit.lua` |

## Risks / Trade-offs

- **[Low] completion.lua eliminado** — Si LazyVim cambia su config de nvim-cmp y deja de incluir algún source, habrá que agregarlo manualmente. Mitigación: fácil de detectar (deja de funcionar autocompletado) y fácil de arreglar (crear spec).
- **[None] Consolidación de standalone + dep** — Las referencias como dep string siguen existiendo en los archivos dependientes (como `dependencies`), solo que sin ser specs completos. lazy.nvim resuelve la dependencia igual.
- **[None] No se eliminan deshabilitados** — Los plugins `enabled = false` se mantienen intactos como están hoy.

## Context

La configuración actual de Neovim está basada en LazyVim con plugins adicionales para lenguajes, herramientas, navegación y UI. Al abrir archivos grandes (>500 líneas), múltiples features computacionalmente intensivas se activan simultáneamente: treesitter fold expression recalcula folds en cada cambio de buffer, gitsigns calcula blame en cada movimiento de cursor, el formateo al guardar se ejecuta dos veces (autocmd manual + conform.nvim), y scrollEOF reacciona a eventos de alta frecuencia. Cada feature individual tiene un costo bajo, pero combinadas crean latencia perceptible.

**Restricciones:**
- No añadir nuevas dependencias externas ni plugins.
- Mantener compatibilidad con la estructura LazyVim existente.
- Los cambios deben ser reversibles individualmente.
- Preservar toda la funcionalidad actual — solo diferir o desactivar ejecución costosa.

## Goals / Non-Goals

**Goals:**
- Reducir latencia de apertura de archivos >500 líneas en al menos un 40%.
- Eliminar el cálculo duplicado de format-on-save.
- Mover el blame de gitsigns de síncrono a diferido o bajo demanda.
- Desactivar foldmethod treesitter para archivos grandes con alternativa rápida.
- Reducir plugins cargando en eventos de alta frecuencia (BufEnter, CursorMoved).

**Non-Goals:**
- No se busca reducir startup time de Neovim (aunque puede mejorar marginalmente).
- No se modifican keymaps ni comportamientos visibles para archivos pequeños.
- No se cambia la experiencia de edición de lenguajes específicos.
- No se introducen nuevos plugins ni dependencias.

## Decisions

### 1. Foldmethod: Indent + foldexpr lazy por defecto, treesitter solo bajo demanda

**Opción elegida:** Cambiar `foldmethod = "expr"` con `foldexpr = "v:lua.vim.treesitter.foldexpr()"` a `foldmethod = "indent"` con `foldlevel = 99` (todo expandido por defecto), y crear un comando `:FoldTS` para cambiar a treesitter folding on-demand.

**Alternativas consideradas:**
- **lazy_fold plugin**: Requeriría añadir una dependencia externa (viola restricciones).
- **Solo desactivar fold por completo**: Se pierde funcionalidad disponible hoy.
- **Foldmethod manual**: Configuración manual tediosa.

**Racional:** Treesitter fold es la causa #1 documentada de lentitud en archivos grandes. `foldmethod=indent` con `foldlevel=99` es órdenes de magnitud más rápido y visualmente idéntico (todo abierto). El comando `:FoldTS` permite recuperar treesitter folding cuando se necesita explícitamente.

### 2. Formateo al guardar: Eliminar autocmd BufWritePre manual

**Opción elegida:** Eliminar el autocmd `BufWritePre` en `autocmds.lua` (líneas 8-19) que itera todos los LSP clients y formatea. `conform.nvim` ya está configurado con `format_on_save` y `lsp_fallback = true`.

**Racional:** El autocmd manual hace lo mismo que conform pero peor: formatea con TODOS los LSP providers en lugar de usar el formateador configurado por filetype, y se ejecuta en cada buffer sin excepción. Conform ya maneja esto con mejor control (timeout, filtrado por ft, disable flag).

### 3. Gitsigns blame: Diferido con delay

**Opción elegida:** Mantener `current_line_blame = true` pero añadir `current_line_blame_opts = { delay = 500 }` para que el blame solo se calcule después de 500ms de inactividad del cursor, no en cada movimiento.

**Alternativas consideradas:**
- **Deshabilitar completamente**: Se pierde una feature útil.
- **Toggle manual con keymap**: Curva de aprendizaje innecesaria.

**Racional:** El delay de 500ms elimina el costo en movimientos rápidos (navegación normal) pero preserva la feature al detenerse en una línea. En archivos grandes, el blame se calcula una vez, no N veces por segundo.

### 4. scrollEOF.nvim: Mover a VeryLazy

**Opción elegida:** Cambiar el evento de `{ "CursorMoved", "WinScrolled" }` a `VeryLazy`.

**Racional:** scrollEOF es una feature cosmética menor que no necesita activarse en cada movimiento de cursor. `VeryLazy` lo carga después del startup sin impacto en la experiencia de edición.

### 5. Treesitter indent: Deshabilitar

**Opción elegida:** Deshabilitar `indent.enable = true` en la configuración de nvim-treesitter.

**Racional:** El indent con treesitter agrega overhead de parseo en cada cambio. Neovim 0.10+ tiene indent nativo mejorado que funciona sin treesitter. La diferencia es imperceptible en archivos pequeños pero notable en grandes.

### 6. mousemoveevent: Deshabilitar

**Opción elegida:** Cambiar `opt.mousemoveevent = true` a `opt.mousemoveevent = false`.

**Racional:** Esta opción dispara el evento `MouseMove` en cada píxel de movimiento del mouse. Es útil solo para UI que reacciona al hover (como dropbar.nvim) pero dropbar está deshabilitado en esta configuración. Sin consumidores del evento, es overhead puro.

### 7. Eventos de plugins diferidos

**Opción elegida:** Mover estos plugins a eventos menos agresivos:
- `harpoon`: de `BufEnter` a `VeryLazy`
- `regexplainer`: de `BufEnter` a `VeryLazy`
- `vim-surround`: de `BufReadPost` a `VeryLazy` (manteniendo `keys` implícito)

**Racional:** `BufEnter` se dispara cada vez que se cambia de buffer — en un archivo grande, cambiar a otro buffer y volver dispara toda la lógica de nuevo. `VeryLazy` asegura que carguen después del startup pero antes de que el usuario los use.

## Risks / Trade-offs

- **[Riesgo] Foldmethod indent es menos preciso que treesitter** → Mitigación: `foldlevel=99` mantiene todo abierto (sin folds visibles), idéntico a la experiencia actual. El usuario puede ejecutar `:FoldTS` si necesita folding semántico.
- **[Riesgo] Conform no cubre todos los casos de BufWritePre** → Mitigación: Conform ya tiene `lsp_fallback = true` que maneja cualquier formateador LSP. El autocmd manual era una implementación genérica menos óptima.
- **[Trade-off] Menos overhead = menos features automáticas** → El blame con delay de 500ms es transparente; scrollEOF sigue funcionando pero sin reaccionar en tiempo real (aceptable para feature cosmética).
- **[Riesgo] Alguien podría depender de mousemoveevent** → Mitigación: No hay plugins activos que lo usen (dropbar deshabilitado). Revertir es trivial.

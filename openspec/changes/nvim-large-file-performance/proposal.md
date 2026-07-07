## Why

Al abrir o editar archivos extensos (>500 líneas), Neovim presenta una latencia notable tanto en la apertura como durante la edición. La causa raíz es una combinación de features computacionalmente costosas activadas por defecto (folding basado en treesitter, cálculo de blame en cada movimiento, formateo duplicado al guardar) que escalan cuadráticamente con el tamaño del archivo. Optimizar estos cuellos de botella mejora la experiencia diaria sin sacrificar funcionalidad.

## What Changes

- **Foldmethod**: Reemplazar `treesitter` folding por `lazy-fold` (solo fold al invocarlo explícitamente), o `indent` + `lazy_fold` como alternativa rápida. El fold por treesitter es la causa #1 de lentitud documentada en archivos grandes.
- **mousemoveevent**: Deshabilitar `mousemoveevent = true` (o moverlo a solo terminal) para reducir eventos innecesarios.
- **Formateo duplicado**: Eliminar el autocmd `BufWritePre` manual (autocmds.lua:8-19) que formatea con todos los LSP clients, y dejar que `conform.nvim` maneje el formateo al guardar (ya configurado).
- **Gitsigns blame diferido**: Cambiar `current_line_blame = true` a `current_line_blame = false` con un toggle manual, o usar `current_line_blame_opts.delay` para no calcular blame en cada cursor move.
- **scrollEOF.nvim**: Mover de eventos `CursorMoved`/`WinScrolled` (alta frecuencia) a `VeryLazy`.
- **Treesitter indent**: Deshabilitar `indent.enable = true` o hacerlo lazy.
- **Eventos de plugins**: Revisar plugins que cargan en `BufEnter`/`BufReadPost` (harpoon, regexplainer, vim-surround, crates.nvim) y diferirlos a eventos menos agresivos.

## Capabilities

### New Capabilities

- `treesitter-folding`: Estrategia de folding optimizada para archivos grandes — fold bajo demanda, no en cada cambio de buffer. Usa `lazy_fold` o foldmethod `indent` con foldlevel 99 por defecto.
- `buffer-events`: Política de eventos de buffer optimizada — plugins que cargan en `BufEnter`/`BufReadPost` se mueven a `VeryLazy` o `LspAttach` según corresponda.
- `format-on-save`: Eliminación del formateo duplicado — consolidar toda la lógica de format-on-save en `conform.nvim`, eliminar el autocmd `BufWritePre` genérico.
- `cursor-move`: Computación perezosa en movimientos de cursor — blame y scrollEOF no se ejecutan en cada cambio de cursor.

### Modified Capabilities

<!-- No existing specs are being modified; all changes are new optimizations. -->

## Impact

- **Archivos modificados**: `zsh/modules/nvim/data/lua/config/options.lua`, `zsh/modules/nvim/data/lua/config/autocmds.lua`, `zsh/modules/nvim/data/lua/config/lazy.lua`, `zsh/modules/nvim/data/lua/plugins/tools/git.lua`, `zsh/modules/nvim/data/lua/plugins/text/scrolleof.lua`, `zsh/modules/nvim/data/lua/plugins/navigation/harpoon.lua`, `zsh/modules/nvim/data/lua/plugins/text/regexplainer.lua`, y archivos de lang/ que usan `lazy = false`.
- **Sin cambios de API ni dependencias externas** — solo reconfiguración interna.
- **Riesgo bajo**: Cada cambio es reversible y no modifica el comportamiento visible para archivos pequeños/medianos. El comportamiento actual se preserva pero con ejecución diferida o perezosa.

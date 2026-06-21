## Context

El módulo `zsh/modules/nvim/` tiene una configuración NvChad v2.5 funcional pero carece de una capa de abstracción que otros proyectos han resuelto con patrones reutilizables. El repositorio `nvchad-config` de Gaston (`mgastonportillo`) implementa una capa `lua/gale/` con utilidades, keymap wrapper, `on_attach` componible, y factory de pickers que podemos adaptar para nuestro módulo.

Estado actual:
- `data/lua/plugins/init.lua` es un archivo manual con ~40 imports — propenso a errores cuando se añaden/quitan plugins
- Los keymaps están dispersos entre `mappings.lua`, `chadrc.lua`, y los specs individuales
- Cada LSP server en `configs/lspconfig.lua` repite el patrón `on_attach` con keymaps
- No hay forma de sincronizar cambios desde `~/.config/nvim/` de vuelta a `data/`
- Las funciones helper están inline en cada archivo en vez de centralizadas

## Goals / Non-Goals

**Goals:**
- Crear capa `lua/jasper/` con utilidades reutilizables (keymap wrapper, debounce, combine_lists)
- Implementar sistema de `on_attach` componible para LSP servers
- Implementar Telescope picker factory con layouts reutilizables
- Crear script de auto-generación de `plugins/init.lua`
- Añadir comando `nvim::backup` para sync inverso
- Añadir \`task build\` en \`Taskfile.yml\` para auto-generar plugins/init.lua

**Non-Goals:**
- No cambiar la estructura existente de `config/`, `internal/`, `pkg/` (solo añadir)
- No migrar a otra versión de NvChad
- No cambiar plugins existentes ni sus configuraciones
- No agregar nuevos plugins externos

## Decisions

### 1. Nombre de la capa: `jasper/` vs `custom/` vs `core/`
**Decisión:** `jasper/` (personal, como `gale/` en nvchad-config)
**Alternativas:** `custom/` (genérico), `core/` (confuso con NvChad core)
**Razón:** Sigue el mismo patrón de personal branding que `gale/`, evitando colisión con namespaces de NvChad.

### 2. Keymap wrapper: función `map()` vs tabla declarativa
**Decisión:** Función `jasper.map(mode, lhs, rhs, desc, opts)` con wrapper `jasper.nnoremap`, `jasper.inoremap`, etc.
**Alternativas:** Tabla declarativa única (como `which-key`), wrapper solo de `vim.keymap.set`
**Razón:** La función es más flexible y componible. Sigue el patrón probado de `gale/utils.lua`. Los wrappers por modo reducen boilerplate.

### 3. `on_attach` componible vs monolithic function
**Decisión:** Tabla de "features" con enable/disable, cada feature es un bloque autocontenido (keymaps, diagnostics, formatting, hover).
**Alternativas:** Función monolithic que hace todo, sistema de callbacks por evento
**Razón:** La tabla permite componer por LSP server (e.g., `ts_ls` no necesita formatting pero `gopls` sí), y es fácil de extender.

### 4. Auto-import script: Lua vs shell
**Decisión:** Script Lua ejecutable desde Neovim vía `:luafile` o desde CLI con `nvim --headless`
**Alternativas:** Shell script con `find`/`sed`, Lua inline en `plugin.zsh`
**Razón:** Ya estamos en contexto Neovim/Lua, y el script puede usar las APIs de Neovim para validar los specs. Sigue el patrón de `scripts/update-lazy-imports.lua` de nvchad-config.

### 5. Telescope picker factory vs configs individuales
**Decisión:** Tabla de presets de layout (vertical, horizontal, tiny, full) + función `jasper.telescope.picker(name, opts)` que aplica el preset.
**Alternativas:** Configs individuales por picker, wrapper global de Telescope
**Razón:** Los presets reutilizables cubren el 90% de los casos sin acoplar la lógica a Telescope internals. Sigue el patrón `gale/telescope.lua`.

### 6. Backup sync: wrapper zsh vs rsync inverso
**Decisión:** Comando zsh `nvim::backup` que ejecuta `rsync` inverso: `$NVIM_CONFIG_PATH/ → data/` con dry-run opcional.
**Alternativas:** Symlink bidireccional, git submodule, unison
**Razón:** Consistente con el patrón existente de `nvim::sync`. El dry-run permite ver qué cambiaría antes de ejecutar. No añade dependencias.

### 7. Estructura de `lua/jasper/`
```
lua/jasper/
├── init.lua          # Entry point, require all modules
├── utils.lua         # Helper functions (glb_map, debounce, word_count, combine_lists)
├── keymaps.lua       # Keymap wrapper functions
├── lsp.lua           # Composable on_attach generator
├── telescope.lua     # Picker factory with layout presets
└── autocmds.lua      # Auto-commands modulares
```

## Risks / Trade-offs

- **[Riesgo] Solapamiento con utilidades de NvChad**: NvChad ya provee algunas funciones helper. Podría haber conflicto de nombres.
  → **Mitigación**: Prefijar todo con `jasper.` y documentar en init.lua qué provee cada módulo.

- **[Riesgo] Script de auto-import puede ser frágil**: Si la estructura de directorios cambia, el script podría generar un `init.lua` inválido.
  → **Mitigación**: El script solo opera sobre `plugins/spec/` y `plugins/override/`, con validación de que cada archivo retorna una spec de lazy.nvim.

- **[Riesgo] Backup sync puede sobrescribir cambios no deseados**: Si alguien edita `data/` directamente y luego hace backup, se perderían cambios locales.
  → **Mitigación**: `nvim::backup` usa `--dry-run` por defecto, requiere flag `--apply` para ejecutar.

- **[Trade-off] Más archivos = más complejidad**: La capa `jasper/` añade ~6 archivos nuevos al proyecto.
  → **Beneficio**: Reduce duplicación en los ~80 specs de plugins, haciendo cada spec más legible.

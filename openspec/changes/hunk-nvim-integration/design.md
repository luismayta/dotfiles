## Context

El módulo `ai` ya gestiona hunk completamente: instalación via npm, PATH loading, wrapper functions (`ai::hunk::review`, `ai::hunk::show`, `ai::hunk::daemon::start`), aliases shell (`hunk-review`, `hunk-show`, `hunk-watch`), y config template sync. El módulo `nvim` tiene un ecosistema LazyVim con ~30 plugin specs organizados por categoría. Los plugins de git existentes son `diffview.nvim`, `gitsigns.nvim`, `neogit` y `vim-fugitive`.

Hunk **no es un plugin Neovim** — es un CLI TUI independiente. La integración debe puentear el CLI de hunk hacia Neovim mediante comandos, keymaps y terminal flotante, sin duplicar la gestión de instalación que ya existe en el módulo `ai`.

## Goals / Non-Goals

**Goals:**
- Proveer comandos de Neovim (`:HunkDiff`, `:HunkShow`, `:HunkDaemon`) para lanzar hunk desde el editor
- Definir keymaps `<leader>h*` para acceso rápido a hunk
- Ejecutar hunk en una terminal flotante (Snacks.nvim terminal o `:terminal`) sin bloquear la UI de Neovim
- Seguir la convención LazyVim: plugin spec en `plugins/tools/hunk.lua` con lazy-loading por comando
- Detectar si hunk está instalado y mostrar mensaje claro si no lo está

**Non-Goals:**
- Gestionar la instalación de hunk (eso ya lo hace el módulo `ai` / `ai::hunk::install`)
- Reemplazar diffview.nvim, neogit o gitsigns — hunk es complementario
- Crear un TUI propio dentro de Neovim — hunk corre en su propia terminal
- Integración con Telescope (se puede añadir después si es necesario)

## Decisions

1. **Estrategia de plugin spec virtual** → Se crea `plugins/tools/hunk.lua` como un spec Lazy.nvim con `config = function() ... end` que define comandos y keymaps, pero sin `require("hunk")` ni plugin externo. Esto mantiene consistencia con el sistema LazyVim y permite lazy-loading vía `cmd`.

2. **Terminal flotante con Snacks.nvim** → Snacks ya está integrado en el módulo nvim (ver `snacks.lua`). Usar `Snacks.terminal` con layout flotante da una experiencia nativa y consistente con el resto del ecosistema Neovim. Alternativa: `:terminal` directo, pero Snacks ofrece mejor UX (toggling, floating window). **Decisión:** Snacks.terminal.

3. **Prefijo de keymaps `<leader>h`** → Sigue el patrón existente (`<leader>dv` para diffview, `<leader>gg` para neogit, `<leader>gc` para git commits en Telescope). `<leader>hd` = hunk diff, `<leader>hs` = hunk show, `<leader>hdm` = hunk daemon.

4. **No duplicar validación de instalación** → No es necesario porque el módulo `ai` ya se asegura de que hunk esté en `$PATH`. Si no está, Neovim fallará naturalmente al ejecutar el comando. Se puede agregar un check opcional con `vim.fn.executable("hunk")`.

5. **Hunk daemon como toggle** → Comando `:HunkDaemon` que ejecuta `hunk daemon serve &` en background. Un segundo llamado mata el proceso. Esto sigue el mismo patrón del wrapper `ai::hunk::daemon::start`.

## Risks / Trade-offs

- **[Riesgo] Dependencia de Snacks.terminal**: si Snacks se deshabilita o remueve, la terminal flotante no funciona → **Mitigación**: fallback a `:terminal` estándar o `vim.fn.jobstart` con `term_open_cmd`.
- **[Riesgo] Hunk no instalado**: si el módulo `ai` no se cargó, hunk no estará en `$PATH` → **Mitigación**: check `vim.fn.executable("hunk")` en la función `config` y mostrar `vim.notify` de advertencia.
- **[Trade-off] Plugin spec virtual**: no tiene un plugin real que instalar, pero LazyVim espera que los specs apunten a un repositorio → **Mitigación**: se usa un string vacío como nombre del plugin o se documenta que es un spec "tool-only".

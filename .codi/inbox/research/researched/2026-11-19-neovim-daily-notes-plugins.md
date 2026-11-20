---
type: research
status: researched
source: web
captured_at: "2026-11-20T04:16:07Z"
tags:
  - nvim
  - plugins
  - daily-notes
  - obsidian
  - note-taking
---

# Neovim Daily Notes Plugins (tipo Obsidian)

## Hallazgos

### Requisitos cubiertos

Sí existen plugins para nvim que replican el flujo de daily notes de Obsidian:
1. Nota por día con fecha en el nombre (`YYYY-MM-DD.md`).
2. Raíz centralizada en una ruta absoluta fija, independiente del cwd.
3. Abrible desde cualquier directorio (comando global).

### Candidatos (hechos verificados)

| Candidato | Daily notes | Root fijo (cwd-independiente) | Abrible desde cualquier dir | Deps | Mantenimiento | Veredicto |
|---|---|---|---|---|---|---|
| journal.nvim (jakobkhansen) | `:Journal day`, format configurable | `root` string/función | Sí | Ninguna | 2026-05-12 / 1 issue | **Fits** |
| obs.nvim (IlyasYOY) | `:ObsNvimDailyNote` | `journal.home` absoluto | Sí | Neovim 0.11+ | 2026-09-08 / 0 issues | **Fits** |
| daily-notes.nvim (fdavies93) | `:DailyNote day` | `writing.root` | Sí | Neovim, Unix | 2026-02-22 / 0 issues | **Fits** (AGPL) |
| obsidian.nvim (obsidian-nvim) | `:Obsidian today` | workspace `path` absoluto | Sí (fallback a workspace) | Neovim ≥0.11, ripgrep opc. | 2026-11-18 / 50 issues | **Fits** (sobrecarga "vault") |
| telekasten.nvim | `goto_today` (nombre hardcodeado) | `home` | Sí | telescope obligatorio | 2026-03-17 / 65 issues | Fits (mant. menor) |
| vimwiki | diario por fecha | `g:vimwiki_list` | Sí | VimScript, filetype global | 233 issues | Partial |
| Neorg | `:Neorg journal today` (.norg) | workspace fijo | Sí | treesitter | Activo | Partial (formato .norg) |
| org-roam.nvim | dailies | Sí | Sí | orgmode + SQLite | 26 issues | Partial (ecosistema pesado) |
| orgmode.nvim | **No** (solo agenda/capture) | N/A | N/A | — | Activo | **No fit** |

### Hallazgos clave

- **Hecho:** `orgmode.nvim` NO incluye daily notes en core; dailies viven en `org-roam.nvim`.
- **Hecho:** `obsidian.nvim` funciona fuera del vault vía `resolve_workspace_dir()` con fallback a `Obsidian.workspace`, pero impone el concepto de "vault".
- **Hecho:** `journal.nvim` usa `filetype = 'md'` por defecto → crea archivos Markdown; la extensión se añade al `format` (ej. del repo: `format = '%Y/quarter/2'` → `2024/quarter/2.md`).
- **Hecho:** por defecto la ruta es anidada (`%Y/%m-%B/daily/%d-%A`); para estilo Obsidian plano hay que configurar `journal.entries.day.format = '%Y-%m-%d'` (NO `journal.format`, que solo aplica al `:Journal` sin tipo).
- **Hecho:** solución nativa de ~6 líneas (`nvim_create_user_command` + `os.date("%Y-%m-%d")` + ruta absoluta vía `vim.fn.expand`) cumple los 3 requisitos sin dependencias.
- **Inferencia:** journal.nvim, obs.nvim y daily-notes.nvim cumplen estrictamente los 3 requisitos; la diferencia real es mantenimiento y complejidad.

### Relación con el codebase

- Fuente de verdad: `zsh/modules/nvim/data/` → sincronizada a `~/.config/nvim` por rsync (`nvim::internal::sync` en `internal/base.zsh`); editar en `data/` y desplegar con `nvim::sync` o `nvim::install`.
- Plugin manager: **lazy.nvim**, auto-descubre specs en `zsh/modules/nvim/data/lua/plugins/*.lua` (un archivo por plugin, spec con `return { "owner/repo", ... }`).
- Verificación: `task lint` (luac -p) + StyLua (`.stylua.toml`, column_width 120, 2 espacios).
- **Recomendación de implementación:** crear `zsh/modules/nvim/data/lua/plugins/journal.lua`.

### Recomendación

1. **`journal.nvim`** — ligero, MIT, cumple exactamente los 3 requisitos:

   ```lua
   require("journal").setup({
     filetype = "md",
     root = "~/notes/daily",
     journal = {
       entries = {
         day = {
           format = "%Y-%m-%d",          -- → ~/notes/daily/2026-11-19.md
           template = "# %A %B %d %Y\n",
         },
       },
     },
   })
   -- uso: :Journal day
   ```

2. **`obs.nvim`** — si además se quiere la estética/wiki-links de Obsidian (`journal.home` absoluto).
3. **Nativo** — cero dependencias si se prefiere minimalismo.


## Fuentes

- https://github.com/jakobkhansen/journal.nvim (README: filetype, format, entries, templates)
- https://github.com/IlyasYOY/obs.nvim (README, lua/obs/vault.lua)
- https://github.com/obsidian-nvim/obsidian.nvim (README, lua/obsidian/api.lua, lua/obsidian/daily/init.lua)
- https://github.com/fdavies93/daily-notes.nvim (README, lua/daily-notes/config.lua)
- https://github.com/nvim-telekasten/telekasten.nvim (README)
- https://github.com/vimwiki/vimwiki (README)
- https://github.com/nvim-neorg/neorg (lua/neorg/modules/core/journal/module.lua)
- https://github.com/nvim-orgmode/orgmode (README)
- https://github.com/chipsenkbeil/org-roam.nvim (código dailies)
- GitHub API (fechas de push e issues abiertos)


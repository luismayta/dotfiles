# HAD-88: Migrar la configuración del módulo nvim para compatibilidad con nvim 0.12

## Contenido Fuente

### Scenario

Migrar la configuración de Neovim en el módulo `zsh/modules/nvim/` para soportar nvim 0.12. La configuración actual utiliza LazyVim v8 con 57+ plugins y múltiples servidores LSP. Se tomará como referencia la configuración de https://github.com/Sin-cy/dotfiles que ya utiliza características de nvim 0.12 como `vim._core.ui2`.

#### Breaking Changes de nvim 0.12 (verificar en config actual)

| Cambio | Acción requerida |
| --- | --- |
| `vim.diagnostic.disable()` eliminado | Reemplazar con `vim.diagnostic.enable(false)` |
| `vim.diagnostic.is_disabled()` eliminado | Reemplazar con `not vim.diagnostic.is_enabled()` |
| Firma legacy de `vim.diagnostic.enable()` no soportada | Usar nueva firma: `enable(bufnr, opts?)` |
| `vim.diff` renombrado a `vim.text.diff` | Actualizar todas las llamadas |
| `vim.lsp.semantic_tokens` `start()/stop()` renombrados | Usar `enable()` en su lugar |
| `vim.lsp.util.convert_signature_help_to_markdown_lines()` | Verificar manejo de `activeParameter` (ahora `activePreselectIndex`) |

#### Nuevas APIs de nvim 0.12 (evaluar adopción)

| API | Descripción | Evaluar |
| --- | --- | --- |
| `vim._core.ui2` | UI nativa para mensajes y commandline (experimental) | Reemplazar noice.nvim |
| `vim.pack` | Plugin manager built-in (desde vim.pack.fetch) | Reemplazar lazy.nvim |
| `:Undotree` | Visualización built-in de undo tree | Reemplazar undotree.nvim |
| `:DiffTool` | Comparación de directorios built-in | Reemplazar diffview.nvim |
| `vim.lsp.completion.enable()` | Completion nativa con opción `cmp` | Reemplazar nvim-cmp |
| `vim.lsp.buf.workspace_diagnostics()` | Diagnostics de workspace | Agregar si no existe |
| `vim.lsp.inlayhints` | Inlay hints nativos | Reemplazar lsp-inlayhints.nvim |
| `vim.lsp.config` / `vim.lsp.enable` | Setup simplificado de LSP | Simplificar configuración LSP |
| `vim.pos`, `vim.range` | Abstracción Position/Range (experimental) | Usar si mejora compatibilidad |
| `vim.list.unique()`, `vim.list.bisect()` | Utilidades de listas | Usar donde aplique |
| `vim.json.encode()` con `indent` | Encode JSON con indentación | Usar para debug/output |
| `DiffTextAdd` highlight | Highlight para texto añadido en diffs | Agregar a colorscheme |

#### Cambios por sección de configuración

##### 1. `config/options.lua` - Opciones de editor

```lua
-- nvim 0.12 ahora tiene estos por defecto (verificar no estén duplicados):
-- termguicolors = true   (ahora default)
-- softtabstop = -1       (ahora default)
-- breakindent = true     (ahora default)
-- inccommand = "nosplit" (ya era default en 0.11)

-- Agregar si no existe:
vim.opt.textwidth = 80    -- para formatoptions con 'j' (nuevo default en 0.12)
```

##### 2. `config/lsp.lua` - Configuración LSP

```lua
-- OPCIÓN A: Usar nueva API simplificada de 0.12
vim.lsp.config('gopls', {
  settings = { ... },
})
vim.lsp.enable('gopls')

-- OPCIÓN B: Mantener mason.nvim + lspconfig (compatible)
-- Verificar que lspconfig soporte las nuevas APIs

-- IMPORTANTE: Inlay hints nativos
vim.lsp.inlayhints.enable()
vim.keymap.set("n", "<leader>uh", function()
  vim.lsp.inlayhints.enable(not vim.lsp.inlayhints.is_enabled())
end, { desc = "Toggle Inlay Hints" })
```

##### 3. `config/keymaps.lua` - Mapeos

```lua
-- Verificar que estos mapeos no usan APIs eliminadas:
-- vim.diagnostic.disable() → vim.diagnostic.enable(false)
-- vim.lsp.buf.range_formatting() → vim.lsp.buf.format({ range = ... })
```

##### 4. `plugins/init.lua` - Plugins

```lua
-- Plugins que pueden ser eliminados (reemplazados por built-in):
-- { "nvimtools/noice.nvim", enabled = false },  -- usar vim._core.ui2
-- { "mbbill/undotree", ... },                   -- usar :Undotree
-- { "sindrets/diffview.nvim", ... },            -- usar :DiffTool

-- Plugins que requieren verificación:
-- { "hrsh7th/nvim-cmp", ... },                  -- evaluar vim.lsp.completion
-- { "simrat39/inlayhints.nvim", ... },          -- reemplazar con vim.lsp.inlayhints
```

##### 5. `config/autocmds.lua` - Autocommands

```lua
-- nvim 0.12 ahora usa 'j' por defecto en formatoptions
-- Verificar que no haya overrides explícitos que pierdan este comportamiento

-- Verificar que vim.lsp.semantic_tokens usa enable() no start()/stop()
```

#### Plugins a evaluar para compatibilidad con nvim 0.12

| Plugin | Verificar | Acción posible |
| --- | --- | --- |
| `lsp-inlayhints.nvim` | ❌ | Reemplazar con `vim.lsp.inlayhints` built-in |
| `noice.nvim` | ⚠️ | Evaluar `vim._core.ui2` como reemplazo |
| `undotree` | ⚠️ | Evaluar `:Undotree` built-in |
| `diffview.nvim` | ⚠️ | Evaluar `:DiffTool` built-in |
| `nvim-cmp` | ⚠️ | Evaluar `vim.lsp.completion.enable()` |
| `rustaceanvim` v5 | ✅ | Verificar changelog para 0.12 |
| `crates.nvim` v0.3 | ✅ | Verificar compatibilidad |
| `mason-tool-installer` | ✅ | Verificar con nuevos LSP APIs |
| `conform.nvim` | ✅ | Verificar compatibilidad |
| `typescript-tools.nvim` | ✅ | Verificar que use APIs actualizadas |

### Acceptance Tests

#### Core functionality

- [ ] Neovim inicia sin errores en nvim 0.12
- [ ] `:checkhealth` no muestra warnings de APIs deprecadas
- [ ] `vim.diagnostic.enable(false)` funciona correctamente
- [ ] `vim.text.diff` funciona (si se usa en config)
- [ ] `vim.lsp.semantic_tokens.enable()` funciona

#### LSP

- [ ] Go: gopls carga, completion funciona, inlay hints nativos funcionan
- [ ] Rust: rust-analyzer carga, hover/signature help funcionan
- [ ] TypeScript: tsserver/neovim carga, completion funciona
- [ ] Python: pyright/pylsp carga, linting funciona
- [ ] `:LspInfo` muestra todos los servidores conectados

#### Plugins

- [ ] LazyVim extras se cargan sin errores
- [ ] Telescope fuzzy finder funciona
- [ ] neo-tree file explorer funciona
- [ ] Harpoon file navigation funciona
- [ ] Copilot completion funciona
- [ ] Conform format-on-save funciona

#### UI

- [ ] Catppuccin colorscheme se carga correctamente
- [ ] Notifications aparecen correctamente (sea via noice o vim._core.ui2)
- [ ] Statusline/lualine funciona
- [ ] Undostree funciona (built-in o plugin)

#### Integration

- [ ] Tests en Taskfile.yml pasan (`luac -p` para lint)
- [ ] DAP funciona para Go y Python

### Sources

- **Docs oficiales:** https://neovim.io/doc/user/news-0.12/
- **Referencia:** https://github.com/Sin-cy/dotfiles/tree/main/nvim/.config/nvim
- **Config actual:** `zsh/modules/nvim/data/`
- **LazyVim docs:** https://www.lazyvim.org/
- **Repo:** https://github.com/luismayta/dotfiles.git

---

## Enriquecimiento

Status: skipped_no_context_queries

_No context queries (`mcp obsidian:`) found in issue description. Obsidian enrichment skipped._

---

### CodeGraph Enrichment

Status: applied

#### codegraph_explore: `vim.diagnostic nvim config zsh/modules/nvim LazyVim`

Found relevant files in `zsh/modules/nvim/data/`:

- `lua/config/options.lua` — Editor options (37 lines). No `vim.diagnostic` usage found. Key settings: fold (treesitter-based), wrap, clipboard.
- `lua/config/autocmds.lua` — 21 lines. Uses `vim.lsp.get_clients` and `vim.lsp.buf.format` for format-on-save. No deprecated APIs detected.
- `lua/config/keymaps.lua` — 80 lines. No `vim.diagnostic.disable()` or `vim.diagnostic.is_disabled()` calls found. Keymaps are clean of deprecated APIs.
- `lua/plugins/init.lua` — 59 lines. Plugin import manifest. References `plugins.tools.diffview` (potential `:DiffTool` replacement candidate).
- `lua/plugins/ui/ui.lua` — Contains `mbbill/undotree` (potential built-in `:Undotree` replacement candidate) and `nvim-tree/nvim-tree.lua`.
- `lua/plugins/tools/diffview.lua` — 12 lines. `sindrets/diffview.nvim` loaded on `DiffviewOpen`/`DiffviewClose` commands. Candidate for `:DiffTool` replacement.
- `lua/plugins/lang/rust.lua` — 52 lines. Uses `lvimuser/lsp-inlayhints.nvim` as dependency of `rustaceanvim`. **Must migrate** to `vim.lsp.inlayhints` built-in.
- `lua/plugins/lang/typescript.lua` — Uses `vim.lsp.protocol.make_client_capabilities()`.

#### codegraph_search: `vim.lsp`

- `zsh/modules/nvim/data/lua/plugins/lang/typescript.lua:11` — `vim.lsp.protocol.make_client_capabilities()`
- `zsh/modules/nvim/data/lua/config/autocmds.lua:12` — `vim.lsp.get_clients { bufnr = args.buf }`

#### codegraph_search: `noice undotree diffview nvim-cmp inlayhints`

- `zsh/modules/nvim/data/lua/plugins/tools/diffview.lua:1` — diffview plugin definition
- `zsh/modules/nvim/data/lua/plugins/lang/rust.lua:25` — `require("lsp-inlayhints")` usage

#### Key Observations from CodeGraph

1. **No `vim.diagnostic.disable()` or `vim.diagnostic.is_disabled()` found** — the config doesn't use these deprecated APIs directly. LazyVim internals may use them.
2. **`vim.lsp.inlayhints`** — `lsp-inlayhints.nvim` is used in `rust.lua:9-10,25`. Must migrate to built-in `vim.lsp.inlayhints`.
3. **`diffview.nvim`** — Present in `tools/diffview.lua`. Evaluate `:DiffTool` as replacement.
4. **`undotree`** — Present in `ui/ui.lua:46-50`. Evaluate built-in `:Undotree`.
5. **`noice.nvim`** — Not directly in config (LazyVim default). Evaluate `vim._core.ui2`.
6. **`nvim-cmp`** — Not directly in config (LazyVim default). Evaluate `vim.lsp.completion.enable()`.
7. **57+ Lua files** in the nvim module — full plugin tree indexed.

#### Full File Listing

```
zsh/modules/nvim/data/lua/config/options.lua
zsh/modules/nvim/data/lua/config/keymaps.lua
zsh/modules/nvim/data/lua/config/lazy.lua
zsh/modules/nvim/data/lua/config/autocmds.lua
zsh/modules/nvim/data/lua/plugins/init.lua
zsh/modules/nvim/data/lua/plugins/ui/{ui,dankcolors,catppuccin,tabby-ml,screenkey,outline,md-preview,focus,edgy,dropbar,ccc}.lua
zsh/modules/nvim/data/lua/plugins/tools/{snacks,luasnip,diffview,conform,cmp-treesitter,searchbox,project,productivity,neogit,git,fine-cmdline,comment,better-escape,b64,autosession,asynctasks}.lua
zsh/modules/nvim/data/lua/plugins/text/{render-markdown,ts-autotag,scrolleof,regexplainer,matchup}.lua
zsh/modules/nvim/data/lua/plugins/navigation/{neo-tree,neocomposer,lsp-signature,hover,hop,harpoon,grug-far,goto-preview}.lua
zsh/modules/nvim/data/lua/plugins/lsp/mason-tools.lua
zsh/modules/nvim/data/lua/plugins/lang/{typescript,sre,rust,python,graphql,go,gleam}.lua
zsh/modules/nvim/data/lua/plugins/dap/{dap-virtual-text,dap-ui}.lua
zsh/modules/nvim/data/lua/plugins/ai/{ai,codesnap}.lua
```

---

## Instrucciones

Genera una especificación OpenSpec en markdown, en inglés, con trazabilidad a HAD-88.

Rules:
- Usa SOLO la información proporcionada — NO inventes información
- Convierte acceptance tests en requerimientos usando MUST / SHOULD / MAY
- Incluye file paths del enrichment como contexto de código relevante

## 1. Fase 0 — Limpieza dentro de NvChad

- [ ] 1.1 Eliminar `scripts/auto-import.lua` y detener `task build`
- [ ] 1.2 Marcar como no cargados los 6 plugins muertos: avante, codecompanion, neocomposer, auto-session, dressing, nvim-colorizer
- [ ] 1.3 Marcar como no cargados plugins UI prescindibles: screenkey, tabby-ml, dropbar
- [ ] 1.4 Verificar que Neovim sigue funcionando sin build step — `:Lazy` muestra plugins cargados correctamente

## 2. Fase 1 — Bootstrap LazyVim

- [ ] 2.1 Crear `lua/config/options.lua` con opciones estándar (number, relativenumber, shiftwidth, etc.)
- [ ] 2.2 Crear `lua/config/keymaps.lua` con leader key `,` y keymaps custom (overrides de defaults de LazyVim)
- [ ] 2.3 Crear `lua/config/autocmds.lua` con autocomandos existentes (highlights, filetypes)
- [ ] 2.4 Crear `lua/config/lazy.lua` con configuración de lazy.nvim
- [ ] 2.5 Crear `lazyvim.json` con extras de editor, coding, DAP, lenguajes y neoconf
- [ ] 2.6 Reescribir `init.lua` para bootstrapear LazyVim en lugar de NvChad
- [ ] 2.7 Verificar que Neovim arranca con LazyVim y `:Lazy` muestra los extras configurados

## 3. Fase 2 — Portar Plugins Custom a lazy.nvim

- [ ] 3.1 Portar Catppuccin como plugin spec file (`lua/plugins/colorscheme.lua`)
- [ ] 3.2 Portar Telescope con presets custom (`lua/plugins/telescope.lua`)
- [ ] 3.3 Portar plugins de editor: matchup, regexplainer, searchbox, fine-cmdline, focus, b64, scroll-eof (`lua/plugins/editor.lua`)
- [ ] 3.4 Portar plugins de UI: ccc, goto-preview (`lua/plugins/ui.lua`)
- [ ] 3.5 Portar plugins de AI: codeium, codesnap (`lua/plugins/ai.lua`)
- [ ] 3.6 Verificar que todos los plugins cargan con `:Lazy` y sus funcionalidades están disponibles

## 4. Fase 3 — Migrar Capa `jasper/` y Eliminar Legacy

- [ ] 4.1 Migrar configuraciones de `lua/jasper/*.lua` a `lua/config/*.lua`
- [ ] 4.2 Migrar configuraciones de `lua/configs/*.lua` a `lua/config/*.lua`
- [ ] 4.3 Migrar overrides de `lua/plugins/override/*.lua` a plugin spec files directos
- [ ] 4.4 Eliminar directorios legacy: `lua/jasper/`, `lua/configs/`, `lua/plugins/`, `scripts/`
- [ ] 4.5 Generar `lazy-lock.json` con `:Lazy lock`
- [ ] 4.6 Verificar integración completa — sesión normal de edición (abrir archivo, buscar, navegar, LSP)

## 5. Verificación Final

- [ ] 5.1 `:checkhealth` sin errores ni warnings críticos
- [ ] 5.2 `:Lazy health` muestra todos los plugins cargados correctamente
- [ ] 5.3 Probar leader key `<Space>` en modo normal — `which-key` muestra bindings
- [ ] 5.4 Probar Telescope (find files, live grep), LSP (goto definition, completion), y git integration
- [ ] 5.5 Confirmar que `task build` ya no es necesario — `git clone` + Neovim es suficiente

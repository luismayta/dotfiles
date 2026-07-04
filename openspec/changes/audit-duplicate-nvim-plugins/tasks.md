## 1. Consolidar telescope.nvim (duplicado en 3 archivos)

- [ ] 1.1 Verificar que telescope en `ui/ui.lua` tiene el spec completo (opts + init + keymaps)
- [ ] 1.2 En `tools/neogit.lua`, cambiar `"nvim-telescope/telescope.nvim"` de spec inline a solo dep string en `dependencies`
- [ ] 1.3 En `ai/ai.lua`, cambiar `"nvim-telescope/telescope.nvim"` de spec inline a solo dep string en `dependencies`

## 2. Consolidar nvim-web-devicons (duplicado en 2 archivos)

- [ ] 2.1 En `ai/ai.lua`, cambiar `"nvim-tree/nvim-web-devicons"` de spec inline a solo dep string

## 3. Consolidar diffview.nvim (duplicado en 3 archivos)

- [ ] 3.1 En `tools/git.lua`, cambiar `dependencies = "sindrets/diffview.nvim"` de spec inline a solo dep string
- [ ] 3.2 En `tools/neogit.lua`, cambiar `"sindrets/diffview.nvim"` de spec inline a solo dep string en `dependencies`

## 4. Refactorizar completion.lua (redundante con LazyVim core)

- [ ] 4.1 Crear `tools/cmp-treesitter.lua` con spec de `ray-x/cmp-treesitter`
- [ ] 4.2 Eliminar `tools/completion.lua`

## 5. Agregar comentarios de dependencia cross-categoría

- [ ] 5.1 Agregar `-- Dep of: tools/neogit.lua, ai/ai.lua` en spec de telescope (`ui/ui.lua`)
- [ ] 5.2 Agregar `-- Dep of: ai/ai.lua, lang/go.lua, text/regexplainer.lua, text/ts-autotag.lua` en spec de treesitter (`ui/ui.lua`)
- [ ] 5.3 Agregar `-- Dep of: ai/ai.lua` en spec de devicons (`ui/ui.lua`)
- [ ] 5.4 Agregar `-- Dep of: tools/git.lua, tools/neogit.lua` en spec de diffview (`tools/diffview.lua`)

## 6. Verificación

- [ ] 6.1 Correr `codi doctor --llm` y confirmar 0 issues de nvim
- [ ] 6.2 Verificar startup con `nvim --headless +"Lazy! sync" +qa`
- [ ] 6.3 Abrir nvim y probar: `<leader>ff` (telescope), `<leader>dv` (diffview), `<leader>gg` (neogit)
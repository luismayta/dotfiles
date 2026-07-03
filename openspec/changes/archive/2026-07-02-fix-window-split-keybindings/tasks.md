## 1. Agregar mappings Ctrl-X en keymaps.lua

- [x] 1.1 Abrir `zsh/modules/nvim/data/lua/config/keymaps.lua` y agregar sección `-- Window splits (Ctrl-X prefix)` al final del archivo
- [x] 1.2 Agregar mapping `map("n", "<C-x>1", "<C-w>o", { desc = "Keep only current window" })`
- [x] 1.3 Agregar mapping `map("n", "<C-x>2", "<cmd>vsplit<CR>", { desc = "Split window vertically" })`
- [x] 1.4 Agregar mapping `map("n", "<C-x>3", "<cmd>split<CR>", { desc = "Split window horizontally" })`

## 2. Verificar ausencia de conflictos

- [x] 2.1 Confirmar que `<C-x>` en insert mode (Codeium) sigue funcionando con `:imap <C-x>` o prueba manual
- [x] 2.2 Confirmar que no hay otros plugins en `lua/plugins/` que listen `<C-x>` en normal mode y puedan interferir
- [x] 2.3 Verificar que LazyVim no tenga defaults que choquen con `<C-x>` como prefijo

## 3. Pruebas y validación

- [x] 3.1 Recargar Neovim y probar `<C-x>1` → split horizontal funcional
- [x] 3.2 Probar `<C-x>2` → split vertical funcional
- [x] 3.3 Probar `<C-x>3` con múltiples ventanas → cierra las demás
- [x] 3.4 Probar `<C-x>3` con una sola ventana → no hace nada (comportamiento esperado)
- [x] 3.5 Probar `<C-x>` en insert mode → Codeium clear (sin interferencia)
- [x] 3.6 Probar navegación `<C-{h,j,k,l}>` entre ventanas después de splits

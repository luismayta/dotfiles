## 1. Extraer y configurar render-markdown.nvim

- [x] 1.1 Remover `render-markdown.nvim` de las dependencias de avante.nvim en `ai/ai.lua`
- [x] 1.2 Crear `text/render-markdown.lua` como plugin independiente con configuración limpia (`sign = false`, `position = "inline"`, `width = "block"`, `link.enabled = false`)

## 2. Corregir keybinding `<leader>e` en neotree

- [x] 2.1 Reemplazar el remap `<leader>e → <leader>fe` por una función que use `vim.fn.expand("%:p:h")` con fallback a `LazyVim.root()`
- [x] 2.2 Verificar que `<leader>fe` mantiene su comportamiento actual (root del proyecto)

## 3. Validación

- [ ] 3.1 Abrir un archivo `.md` y confirmar que `render-markdown` está activo pero sin signos, overlay ni rendering de enlaces
- [ ] 3.2 Probar `<leader>e` en un archivo con ruta → neotree abre en el directorio del archivo
- [ ] 3.3 Probar `<leader>e` en buffer `[No Name]` → neotree abre en root del proyecto
- [ ] 3.4 Probar `<leader>fe` → neotree abre en root del proyecto

## 1. Mover colorschemes a `ui/`

- [x] 1.1 Mover `catppuccin.lua` → `ui/catppuccin.lua` (`git mv`)
- [x] 1.2 Mover `dankcolors.lua` → `ui/dankcolors.lua` (`git mv`)
- [x] 1.3 Actualizar ruta de auto-referencia en `ui/dankcolors.lua` (línea 79: `plugins/` → `plugins/ui/`)

## 2. Mover herramientas a `tools/`

- [x] 2.1 Mover `completion.lua` → `tools/completion.lua` (`git mv`)
- [x] 2.2 Mover `conform.lua` → `tools/conform.lua` (`git mv`)
- [x] 2.3 Mover `luasnip.lua` → `tools/luasnip.lua` (`git mv`)

## 3. Mover explorador a `navigation/`

- [x] 3.1 Mover `neo-tree.lua` → `navigation/neo-tree.lua` (`mv`)

## 4. Actualizar `init.lua` con los nuevos imports

- [x] 4.1 Cambiar `{ import = "plugins.dankcolors" }` → `{ import = "plugins.ui.dankcolors" }`
- [x] 4.2 Agregar `{ import = "plugins.ui.catppuccin" }` en init.lua (junto a dankcolors)
- [x] 4.3 Cambiar `{ import = "plugins.completion" }` → `{ import = "plugins.tools.completion" }`
- [x] 4.4 Cambiar `{ import = "plugins.conform" }` → `{ import = "plugins.tools.conform" }`
- [x] 4.5 Cambiar `{ import = "plugins.luasnip" }` → `{ import = "plugins.tools.luasnip" }`
- [x] 4.6 Agregar `{ import = "plugins.navigation.neo-tree" }` en init.lua (junto a los otros navigation)

## 5. Verificación final

- [x] 5.1 Confirmar que no quedan archivos `.lua` sueltos en `zsh/modules/nvim/data/lua/plugins/` (excepto `init.lua`)
- [x] 5.2 Verificar que `git status` muestre los moved files correctamente (renames, no delete+create)
- [x] 5.3 Ejecutar `codi doctor --llm` para validar que no hay issues de configuración

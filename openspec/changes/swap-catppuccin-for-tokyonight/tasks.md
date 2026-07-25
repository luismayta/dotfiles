## 1. Plugin Spec — Reemplazo de theme

- [ ] 1.1 Eliminar `zsh/modules/nvim/data/lua/plugins/catppuccin.lua`
- [ ] 1.2 Crear `zsh/modules/nvim/data/lua/plugins/tokyonight.lua` con configuración: `style = "storm"`, `terminal_colors = true`, `styles = { comments = { italic = true }, keywords = { italic = true } }`, `vim.cmd.colorscheme "tokyonight"`
- [ ] 1.3 Actualizar `zsh/modules/nvim/data/lua/config/lazy.lua`: cambiar `install.colorscheme` de `"catppuccin"` a `"tokyonight"`

## 2. Plugin Dependencies — Lualine

- [ ] 2.1 En `lualine.lua`: eliminar dependencia `{ "catppuccin/nvim", name = "catppuccin" }` y cambiar `theme = "catppuccin"` a `theme = "auto"` (o eliminar para auto-detección)

## 3. Limpieza de referencias

- [ ] 3.1 Buscar en todo el módulo nvim (`data/lua/`) cualquier referencia residual a `"catppuccin"` y eliminarlas
- [ ] 3.2 Verificar que `plugins/snacks.lua`, `plugins/telescope.lua` y otros no tengan hardcoded catppuccin references

## 4. Verificación

- [ ] 4.1 Abrir Neovim y confirmar que TokyoNight storm se aplica correctamente
- [ ] 4.2 Verificar que lualine, bufferline, neo-tree y telescope usan los colores del theme
- [ ] 4.3 Verificar que `:terminal` muestra los terminal colors de TokyoNight
- [ ] 4.4 Ejecutar `:Lazy` y confirmar que no hay errores de plugin loading

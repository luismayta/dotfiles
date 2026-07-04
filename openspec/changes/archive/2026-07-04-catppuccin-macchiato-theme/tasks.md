## 1. Neovim: Add Catppuccin Plugin Spec

- [ ] 1.1 Create `zsh/modules/nvim/data/lua/plugins/catppuccin.lua` with `catppuccin/nvim` plugin spec, `lazy = false`, Macchiato flavor, and LazyVim integration
- [ ] 1.2 Disable `dankcolors.lua`: set `enabled = false` in `zsh/modules/nvim/data/lua/plugins/dankcolors.lua` plugin table
- [ ] 1.3 Verify that `config/lazy.lua` has `colorscheme = { "catppuccin" }` so lazy.nvim sets it as default after loading

## 2. Starship: Apply Catppuccin Macchiato Palette

- [ ] 2.1 Add global `[palette]` block with Catppuccin Macchiato color variables at the top of `zsh/modules/starship/data/starship.toml`
- [ ] 2.2 Replace all inline color styles in starship modules with palette variable references (directory, character, username, git_state, golang, python, lua, dart, deno, helm, terraform, memory_usage, env_var, custom, etc.)

## 3. Update Specs

- [ ] 3.1 Update `openspec/specs/plugin-colorscheme/spec.md` to reflect macchiato variant (replace mocha → macchiato in requirement text and scenarios)

## 4. Verification

- [ ] 4.1 Load neovim and confirm `:colorscheme` outputs `catppuccin-macchiato`
- [ ] 4.2 Run `starship preset catppuccin-macchiato -o /dev/null` to validate no syntax errors
- [ ] 4.3 Confirm no regressions: neovim UI components (bufferline, which-key, noice) render correctly with new theme

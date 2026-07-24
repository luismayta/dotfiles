## 1. Remap opencode keybinding

- [ ] 1.1 Change `<C-x>` to `<C-z>` in `zsh/modules/nvim/data/lua/plugins/opencode.lua` (line 15, `keys` table entry for "OpenCode: Select")
- [ ] 1.2 Update the `desc` field to reflect the new key ("OpenCode: Select" is fine, but verify no other references)
- [ ] 1.3 Verify `<C-x>*` window management keybindings in `config/keymaps.lua` are unaffected (no changes needed, just validation)

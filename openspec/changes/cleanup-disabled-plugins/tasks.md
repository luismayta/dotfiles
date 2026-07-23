## 1. Delete Disabled Plugin Files

- [ ] 1.1 Delete `navigation/lsp-signature.lua`
- [ ] 1.2 Delete `navigation/hover.lua`
- [ ] 1.3 Delete `tools/searchbox.lua`
- [ ] 1.4 Delete `tools/fine-cmdline.lua`
- [ ] 1.5 Delete `ui/dropbar.lua`
- [ ] 1.6 Delete `ui/screenkey.lua`

## 2. Remove Disabled Plugin Blocks

- [ ] 2.1 Remove `indent-blankline.nvim` spec block from `ui/ui.lua`

## 3. Verify Cleanup

- [ ] 3.1 Run `grep -r "lsp_signature\|hover\|searchbox\|fine-cmdline\|dropbar\|screenkey\|indent_blankline"` to confirm no references remain
- [ ] 3.2 Verify directory structure intact: `ls navigation/ tools/ ui/`
- [ ] 3.3 Run `nvim --headless -c 'checkhealth' -c 'write! /tmp/health.txt' -c 'quit'` to verify no errors

## 4. Documentation

- [ ] 4.1 Update commit message to document removed plugins
- [ ] 4.2 Verify no README or documentation references removed plugins
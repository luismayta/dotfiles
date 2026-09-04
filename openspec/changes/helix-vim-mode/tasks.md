## 1. Normal Mode Vim Keybindings

- [x] 1.1 Add word navigation keys (`w`, `b`, `e`) to `[keys.normal]` (Helix defaults, no change needed)
- [x] 1.2 Add line operations (`dd`, `yy`, `p`) as macros to `[keys.normal]`
- [x] 1.3 Add character find keys (`f`, `F`, `t`, `T`) if not already mapped (Helix defaults, no change needed)

## 2. Insert Mode Exit

- [x] 2.1 Add `jj` sequence to exit insert mode in `[keys.insert]`
- [x] 2.2 Add `jk` sequence to exit insert mode in `[keys.insert]`

## 3. Leader Key ',' Configuration

- [x] 3.1 Create `[keys.normal.","]` minor mode section
- [x] 3.2 Add `,w` → `:write` (save file)
- [x] 3.3 Add `,q` → `:quit` (close buffer)
- [x] 3.4 Add `,e` → `file_picker` (open file picker)
- [x] 3.5 Add `,f` → `global_search` (find in files)

## 4. Preserve Native Selection Mode

- [x] 4.1 Verify `[keys.select]` section retains Helix defaults
- [ ] 4.2 Test that `v` mode still works with all native keybindings

## 5. Testing & Verification

- [ ] 5.1 Sync config to `~/.config/helix/config.toml`
- [ ] 5.2 Test normal mode word navigation (`w`, `b`, `e`)
- [ ] 5.3 Test line operations (`dd`, `yy`, `p`)
- [ ] 5.4 Test insert mode exit (`jj`, `jk`)
- [ ] 5.5 Test leader key sequences (`,w`, `,q`, `,e`, `,f`)
- [ ] 5.6 Verify no conflicts with existing keybindings

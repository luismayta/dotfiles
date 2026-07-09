## 1. Fix fzf preview field index

- [x] 1.1 Change the preview command in `internal/worktree.zsh:137` from `"echo {2} | xargs ls -la"` to `"ls -la {3}"` to reference the correct path field

## 2. Verify

- [x] 2.1 Verify preview command `ls -la {3}` correctly resolves to the worktree path (confirmed: `{2}` → `|`, `{3}` → actual path)
- [x] 2.2 Verify `hrdw::open` uses same `fzf_select` function — fix applies automatically
- [x] 2.3 Confirm `hrdw::remove <id>` (direct, non-interactive) doesn't use fzf — unchanged

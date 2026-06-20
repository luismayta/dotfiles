## 1. Modify project name derivation logic

- [x] 1.1 Replace the name derivation block in `tx::project` (lines 57-59 of `zsh/modules/tmux/pkg/helper.zsh`) to add parent directory context when `$1` is not provided
- [x] 1.2 Implement the two-tier prefix logic: `{parent}-{folder}` for subdirectories, `core-{folder}` when parent is `$HOME`, `core` when PWD is `$HOME`
- [x] 1.3 Ensure the full constructed name (prefix + folder) passes through the existing sanitization pipeline
- [x] 1.4 Verify that explicit `$1` argument bypasses the parent prefix and sanitizes as before

## 2. Verify edge cases

- [x] 2.1 Test with folder containing `.` character
- [x] 2.2 Test with folder containing `'` or `;` characters
- [x] 2.3 Test when PWD is directly under `$HOME`
- [x] 2.4 Test when PWD equals `$HOME` itself
- [x] 2.5 Test with explicit `$1` argument to confirm backward compatibility

## Why

When running `hrdw::remove` without arguments (interactive mode), fzf opens with a preview pane that shows nothing. The preview command references `{2}` to display the worktree directory, but due to fzf's whitespace-based field splitting, `{2}` resolves to the pipe separator (`|`) instead of the actual path. Users get an empty or broken preview, reducing confidence when selecting which worktree to remove.

## What Changes

- Fix the fzf preview command in `hrd::internal::worktree::fzf_select` to reference the correct field index for the worktree path
- Preview will correctly show the directory contents of the selected worktree

## Capabilities

### New Capabilities

None — this is a bug fix, not a new feature.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- **Code**: Single-line change in `zsh/modules/herdr/internal/worktree.zsh` — fix the field index from `{2}` to `{3}` in the preview command passed to `hrd::internal::fzf_select`
- **Dependencies**: None
- **Systems**: Only affects the interactive `hrdw::remove` and `hrdw::open` fzf preview experience

## 🧭 Anchored Summary

**Previous →** RD-20 · feat(herdr) · add pane layout helper, fix fzf preview field index, archive change

### Focus
Refining herdr internal tooling — worktree removal UX, pane layout consistency, and OpenSpec archival.

### Key Decisions
- Swapped pane labels `p2=agent` / `p3=shell` to match conventional left-to-right ordering (editor+shell left, agent right)
- Fixed `fzf_select` preview: field index `{2}` → `{3}` because `ls -la` was being passed as echo argument instead of the actual preview command; the fzf pattern now passes the third column (path) directly to `ls -la`
- Archived the completed `fix-hrdw-remove-preview` change via OpenSpec archive workflow, preserving all artifacts (proposal, design, specs, tasks)

### Active Changes (Working Tree)
- Clean — 3 commits pushed

### Next
Ready for the next task on `feature/RD-20`

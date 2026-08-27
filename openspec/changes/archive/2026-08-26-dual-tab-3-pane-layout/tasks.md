## 1. Modify pane.zsh

- [x] 1.1 Add optional `num_tabs` parameter to `hrd::internal::pane::setup_3_pane_layout` function signature (second positional arg, default=2)
- [x] 1.2 Add validation for `num_tabs` parameter (must be >= 1)
- [x] 1.3 Create loop to generate tabs using `herdr tab create`
- [x] 1.4 For each tab: apply 3-pane layout (split right, split down, rename panes)
- [x] 1.5 Add error handling: continue to next tab if tab creation fails
- [x] 1.6 Add error handling: emit warning if pane split fails, continue
- [x] 1.7 Ensure first tab is focused after completion
- [x] 1.8 Refactor: Extract `setup_tab_layout` helper for single-tab setup

## 2. Test backward compatibility

- [ ] 2.1 Verify `hrd::internal::pane::setup_3_pane_layout "ws_id"` creates 2 tabs (new default)
- [ ] 2.2 Verify `hrd::internal::pane::setup_3_pane_layout "ws_id" 1` creates 1 tab
- [ ] 2.3 Verify `hrd::internal::pane::setup_3_pane_layout "ws_id" 3` creates 3 tabs
- [ ] 2.4 Verify missing workspace ID emits warning and returns 1
- [ ] 2.5 Verify pane failure emits warning but continues execution

## 3. Verify existing callers

- [ ] 3.1 Test `hrd::project` creates workspace with 2 tabs (new default behavior)
- [ ] 3.2 Test `hrdw::create` creates worktree with 2 tabs (new default behavior)
- [ ] 3.3 Verify both callers work without code changes (function signature change only)

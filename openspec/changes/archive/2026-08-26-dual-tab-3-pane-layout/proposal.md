## Why

When working on complex tasks, developers often need multiple contexts open simultaneously — one for coding, another for running tests, debugging, or monitoring. Currently, `hrd::project` creates a single tab with a 3-pane layout. To switch between contexts, users must manually create additional tabs and configure their pane layouts.

This change modifies `hrd::internal::pane::setup_3_pane_layout` to create **2 tabs by default**, each with its own 3-pane layout (editor, shell, agent). Users get a dual-context workflow out of the box.

## What Changes

- **BREAKING**: `hrd::internal::pane::setup_3_pane_layout` now creates **2 tabs by default** (previously 1 tab)
- New optional parameter: `num_tabs` (default: 2) — controls how many tabs to create
- Each tab receives the standard 3-pane layout (editor, shell, agent)
- `hrd::project` and `hrdw::create` will now create 2 tabs automatically

## Capabilities

### Modified Capabilities

- `pane-layout`: Extend to support multi-tab creation with configurable tab count
- `project-workspace-setup`: Default behavior changes from 1 tab to 2 tabs

## Impact

- **Files**: `internal/pane.zsh` — modify `setup_3_pane_layout` function
- **API**: Add optional `num_tabs` parameter (positional, second argument)
- **Dependencies**: No new dependencies
- **Backward compatible**: NO — default changes from 1 tab to 2 tabs
- **Migration**: Users wanting 1 tab must pass explicit `1` as second argument

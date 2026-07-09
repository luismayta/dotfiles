## Why

Two refactors, same root cause: `zsh/modules/herdr/internal/base.zsh` has become a monolith mixing unrelated domains, and the 3-pane IDE layout setup is duplicated inline inside `hrd::project`.

**Pane extraction**: The pane split + rename sequence is inlined inside `hrd::project`. The new `hrdw::create` also needs it but cannot reuse it. Extracting into a reusable function eliminates duplication and ensures consistent layout behavior across both entry points.

**Domain separation**: `internal/base.zsh` currently mixes install helpers, config sync, workspace CRUD (~300 lines), worktree CRUD (~160 lines), and general utilities in a single file. As more domains are added (pane, project, template), this will grow unmanageable. Splitting by domain follows the same pattern already used by `pkg/` directory (`helper.zsh`, `alias.zsh`, `main.zsh`).

## What Changes

**Pane extraction:**
- Add `hrd::internal::pane::setup_3_pane_layout` in `internal/pane.zsh` — encapsulates the pane split right (60%), split down (50%), and rename (`editor`, `shell`, `agent`) sequence
- Replace inline pane commands in `hrd::project` (lines 114–123) with a call to the new function
- Call the new function from `hrdw::create` after successful worktree + workspace creation

**Domain separation:**
- Split `internal/base.zsh` into domain files:
  - `internal/base.zsh` — general utilities: `fzf_select`, `derive_project_name`, `list_templates`, `select_template`, `resolve_workspace_id`
  - `internal/install.zsh` — `install`, `config::sync`
  - `internal/workspace.zsh` — workspace CRUD: `list_workspaces`, `workspace_exists`, `switch_workspace`, `kill_workspace`, `workspace_attach_or_create`
  - `internal/worktree.zsh` — worktree CRUD: all `worktree::*` functions
  - `internal/pane.zsh` — pane layout functions (new)
- Update `internal/main.zsh` sourcing order to include new files
- Remove migrated functions from `internal/base.zsh`
- Update `@internal` references where needed

## Capabilities

### New Capabilities

- `pane-layout`: Reusable 3-pane IDE layout setup for herdr workspaces. Accepts a workspace ID, splits panes (60/40 vertical, then 50/50 horizontal right), and assigns names (`editor`, `shell`, `agent`).
- `internal-module-structure`: Domain-separated internal module files. Defines the file layout, naming conventions, and sourcing order for `zsh/modules/herdr/internal/`.

### Modified Capabilities

*None. No existing spec-level behavior changes.*

## Impact

- `zsh/modules/herdr/internal/base.zsh` — reduced by ~400 lines (functions moved to domain files)
- `zsh/modules/herdr/internal/install.zsh` — new file (install + config functions)
- `zsh/modules/herdr/internal/workspace.zsh` — new file (workspace CRUD functions)
- `zsh/modules/herdr/internal/worktree.zsh` — new file (worktree functions)
- `zsh/modules/herdr/internal/pane.zsh` — new file (pane layout functions)
- `zsh/modules/herdr/internal/main.zsh` — updated sourcing order
- `zsh/modules/herdr/pkg/helper.zsh` — `hrd::project` replaces 10 inline pane lines with function call; `hrdw::create` adds pane setup call

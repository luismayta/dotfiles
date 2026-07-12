## Context

The `hrd::project` function currently inlines 10 lines of pane split + rename commands (lines 114–123 of `helper.zsh`) to set up a 3-pane IDE layout after workspace creation. The new `hrdw::create` command also needs this same layout after creating a worktree workspace, but has no way to reuse it — the logic is buried inside a specific function.

Meanwhile, `internal/base.zsh` has grown to 545 lines across 5 unrelated domains: install, config, workspace (~300 lines), worktree (~160 lines), and general utilities. The `pkg/` directory already demonstrates domain separation (`helper.zsh`, `alias.zsh`, `main.zsh`). The `internal/` directory should follow suit.

Current functions by domain in `base.zsh`:

| Domain | Functions | Lines |
|---|---|---|
| Install | `install`, `config::sync` | 7–46 |
| Workspace | `list_workspaces`, `workspace_exists`, `switch_workspace`, `kill_workspace`, `workspace_attach_or_create` | 48–376 |
| General utils | `fzf_select`, `derive_project_name`, `list_templates`, `select_template`, `resolve_workspace_id` | 123–377 |
| Worktree | `worktree::is_git_repo`, `derive_repo_name`, `branch_exists`, `list`, `create`, `open`, `remove`, `fzf_select`, `resolve_path`, `resolve_workspace_id` | 378–544 |

## Goals / Non-Goals

**Goals:**
- Extract the 3-pane IDE layout setup into a reusable internal function in `pane.zsh`
- Replace inline pane commands in `hrd::project` with a call to the new function
- Call the new function from `hrdw::create` after successful worktree creation
- Keep the same behavior — layout must be identical regardless of entry point
- Split `internal/base.zsh` into domain-specific files following the `pkg/` pattern
- Each new file sources dependencies via `internal/main.zsh` in consistent order
- All existing callers continue working unmodified (import paths are internal)

**Non-Goals:**
- No changes to the pane layout itself (still 60/40 vertical, 50/50 horizontal right)
- No changes to pane naming convention (editor/shell/agent)
- No new CLI commands or user-facing features
- No changes to error handling philosophy (failures are non-fatal warnings)
- No changes to function signatures or naming conventions (prefixes stay `hrd::internal::*`)
- No changes to `pkg/` files beyond the pane extraction call site updates

## Decisions

### Decision 1: Target file layout

```
internal/
├── main.zsh       (sourcing orchestration — unchanged)
├── base.zsh       (general utilities: fzf_select, derive_project_name, list_templates, select_template, resolve_workspace_id)
├── install.zsh    (install, config::sync)
├── workspace.zsh  (workspace CRUD)
├── worktree.zsh   (worktree CRUD)
├── pane.zsh       (pane layout functions — new)
├── linux.zsh      (unchanged)
└── osx.zsh        (unchanged)
```

Each new file gets a `# shellcheck shell=bash` header and domain comment banner, matching the existing style.

### Decision 2: Sourcing order in main.zsh

Dependencies flow: utilities → install → workspace → worktree → pane

The sourcing order in `main.zsh` SHALL be:
```
base.zsh        (utilities — no internal dependencies)
install.zsh     (depends on base helpers like message_*)
workspace.zsh   (depends on base helpers)
worktree.zsh    (depends on base helpers + workspace features like resolve_workspace_id)
pane.zsh        (depends on base helpers)
linux.zsh       (unchanged)
osx.zsh         (unchanged)
```

### Decision 3: Function signature and location for pane setup

- **Location**: `hrd::internal::pane::setup_3_pane_layout` in `internal/pane.zsh`
- **Signature**: `hrd::internal::pane::setup_3_pane_layout ws_id` where `ws_id` is required
- **Why**: Follows existing `hrd::internal::*` naming convention. Its own domain file as it's a new domain.

### Decision 4: How hrdw::create gets the workspace ID

- After `hrd::internal::worktree::create` succeeds, resolve the ws_id via `hrd::internal::resolve_workspace_id "$label"` — the label was already computed before calling create
- **Alternative considered**: Making `worktree::create` capture and return ws_id via stdout. Rejected because it would change the function's contract (currently returns 0/1) and force every caller to manage an extra variable.
- **Why this approach**: Zero changes to `worktree::create`. The resolve call is O(1) since the workspace was just created. Consistent with how `resolve_workspace_id` is used elsewhere.

### Decision 5: Error handling for pane setup

- If any pane split/rename command fails, log a warning via `message_warning` but do NOT abort the overall creation
- **Why**: The workspace and worktree were already created successfully. A pane layout failure is cosmetic, not critical. The user can still use the workspace.
- **Consistent with**: Current behavior of `hrd::project` which lets errors pass silently (no error handling on pane commands)

### Decision 6: hrdw::create integration point

- Call `setup_3_pane_layout` inside `hrdw::create` right after the successful `worktree::create` returns, before `message_success`
- The label is passed to `resolve_workspace_id` to get the ws_id

### Decision 7: Migration strategy

Pure relocation — no logic changes during the split. Each function moves verbatim to its new file except:
- `base.zsh` loses functions but keeps the general utility ones
- `main.zsh` gets new `source` lines for each new file
- No `@internal` or cross-file references change (all functions stay under `hrd::internal::*` namespace)

### Decision 8: Cross-file references

All internal functions use the `hrd::internal::*` namespace. Since Zsh does not enforce file-level visibility, any function in any file can call any other. This is acceptable because:
1. The namespace prefix already signals "internal, not public API"
2. The `pkg/` → `internal/` boundary is the real API contract
3. Zsh modules conventionally rely on namespace discipline, not file boundaries

## Risks / Trade-offs

- **Risk: `resolve_workspace_id` returns empty immediately after creation** → Mitigation: `herdr worktree create --focus` creates the workspace synchronously before returning. If it still fails, the warning is non-fatal; the workspace exists and is focused.
- **Risk: Breaking hrd::project callers** → Mitigation: Pure refactor — the public behavior of `hrd::project` does not change. Same layout, same messages. Only internal plumbing changes.
- **Risk: Wrong sourcing order causes "command not found" at load time** → Mitigation: Explicit dependency order in `main.zsh` (utilities → install → workspace → worktree → pane). Shellcheck catches undefined references.
- **Risk: New files not sourced → functions silently missing** → Mitigation: After editing `main.zsh`, run `exec zsh` and test each domain function. Task 4 covers this.
- **Trade-off**: Adding `resolve_workspace_id` call in `hrdw::create` adds ~20ms latency. Acceptable since worktree creation itself takes ~500ms–2s.
- **Trade-off**: Multiple files means more open tabs during development. Acceptable because each file is smaller and focused on one concern.

---
# herdr::project — Functional Specification

> Baseline spec for a Rust extension that will re-implement this functionality.
> Current implementation (zsh): `hrd::project` in `zsh/modules/herdr/pkg/helper.zsh`, with helpers in
> `internal/base.zsh` (`hrd::internal::derive_project_name`), `internal/workspace.zsh`
> (`hrd::internal::workspace_attach_or_create`, `hrd::internal::switch_workspace`) and
> `internal/pane.zsh` (`hrd::internal::pane::setup_3_pane_layout`).
> `hrd::project` is a port of `tx::project` from the tmux module.

## 1. Purpose

Create a herdr workspace for the current project and set up a 3-pane IDE layout (editor, shell, agent).
If the workspace already exists, offer to attach to it instead of recreating it.

## 2. Interface

```
hrd::project [name]
```

| Argument | Behavior |
|----------|----------|
| `(none)` | Project name derived from directory context (see §3) |
| `name`   | Project name used as-is, then sanitized (see §3) |

### Exit codes

| Code | Meaning |
|------|---------|
| `0`   | Workspace attached (existing) OR workspace created with layout OR user declined attach |
| `1`   | Could not derive a project name, or workspace creation failed |

## 3. Project name derivation

Rules (in order):

1. If an argument is given, use it as the base name.
2. Otherwise derive from `$PWD` and `$HOME`:
   - `$PWD == $HOME` → `core`
   - parent of `$PWD == $HOME` → `core-{current_dir}`
   - otherwise → `{parent_dir}-{current_dir}`
3. Sanitize (slugify): replace every non-alphanumeric character with `-`; collapse consecutive `-` into one; strip leading and trailing `-`; lowercase.

Examples (assuming `$HOME=/home/user`):

| PWD | Result |
|-----|--------|
| `/home/user` | `core` |
| `/home/user/proj` | `core-proj` |
| `/home/user/work/repo` | `work-repo` |
| arg `My.Repo` | `my-repo` |

If the derived name is empty → error `Could not determine a valid project name.`, exit `1`.

## 4. Attach-or-create flow

1. Check whether a workspace with the derived label exists (`herdr workspace list` → compare labels).
2. If it exists: prompt `A herdr workspace "<name>" already exists. Attach? (Y/n)`.
   - Yes (or empty response) → resolve the workspace id and run `herdr workspace focus <id>`.
   - No → do nothing.
   - In both cases the command stops (exit `0`) — the workspace is NOT recreated.
3. If it does not exist: proceed to creation (§5).

## 5. Workspace creation

```
herdr workspace create --label "<name>" --cwd "<current-dir>" --focus
```

- The command returns JSON; extract the id with: `.result.workspace.workspace_id`.
- On command failure → error `Failed to create workspace '<name>'.`, exit `1`.
- `--cwd` is the directory where `hrd::project` was invoked.

## 6. Three-pane IDE layout

Applied after creation (non-fatal — layout failures warn but do not abort).

```
┌──────────────┬─────────────────┐
│  pane 1      │                 │
│  (editor)    │  pane 2         │
├──────────────┤  (agent)        │
│  pane 3      │                 │
│  (shell)     │                 │
└──────────────┴─────────────────┘
```

Commands (pane ids use the form `<workspace_id>:p<N>`):

1. `herdr pane split <ws>:p1 --direction right --ratio 0.5` — right column (p2) reserved for the agent.
2. `herdr pane split <ws>:p1 --direction down --ratio 0.5` — left column split: top-left (p1) editor, bottom-left (p3) shell.
3. Rename panes: `herdr pane rename <ws>:p1 editor`, `herdr pane rename <ws>:p2 agent`, `herdr pane rename <ws>:p3 shell`.

Final pane mapping: `p1` → editor (top-left, 50%), `p3` → shell (bottom-left, 50%), `p2` → agent (right, 100%).

## 7. Dependencies

| Dependency | Use |
|------------|-----|
| `herdr` CLI | `workspace create` / `workspace list` / `workspace focus` / `pane split` / `pane rename` |
| `jq` | Parse workspace JSON output |
| `core::exists` | Feature detection (fzf, etc.) |
| `message_*` | User-facing info/error/success output |

## 8. Configuration

| Variable | Role |
|----------|------|
| `ZSH_HERDR_PATH` | Module root; base for `ZSH_HERDR_DATA_PATH` |
| `ZSH_HERDR_WORKSPACE_PREFIX` | Optional workspace label prefix (unused by `hrd::project` today; reserved) |

## 9. Notes for the Rust implementation

- Replicate: name slugify rules (§3), attach-or-create semantics (§4 — never recreate an existing workspace), JSON field `.result.workspace.workspace_id`, and the exact pane split/rename sequence (§6).
- The 3-pane layout must be idempotent per creation: it runs only on a freshly created workspace.
- Preserve exit-code semantics (§2): `0` = done (attached, created, or declined), `1` = hard failure.
- `--cwd` must be the invocation directory of the original command, not the Rust binary's cwd.
---
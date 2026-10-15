---
# hrd::project — Functional Specification

> Baseline spec for a Rust extension that will re-implement this functionality.
> Current implementation (zsh): `hrd::project` in `zsh/modules/herdr/pkg/helper.zsh`, with helpers in
> `internal/base.zsh` (`hrd::internal::derive_project_name`), `internal/workspace.zsh`
> (`hrd::internal::workspace_attach_or_create`, `hrd::internal::switch_workspace`) and
> `internal/pane.zsh` (`hrd::internal::pane::setup_3_pane_layout`).
> `hrd::project` is a port of `tx::project` from the tmux module.

## Namespace convention

All namespaced functions under `internal/` and `pkg/` use the `hrd::` prefix — for example
`hrd::internal::derive_project_name`, `hrd::internal::workspace_attach_or_create`,
`hrd::project`, `hrd::plugin`. The older mixed prefix these functions once used is retired:
one convention across both layers, no exceptions (design D3 of `refactor-herdr-module`).

Commands are NOT namespaces and are exempt from this rule: `hrd`, `hrdk`,
`edit-herdr-config`, and `edit-herdr-plugins` keep their exact names (design D0).
The frozen public API — `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `hrd::plugin`,
`hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`, `edit-herdr-config`,
`edit-herdr-plugins` — is never renamed.

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

1. If an argument is given, use it as the base name (the prefix map is NOT consulted; parent directories are irrelevant).
2. Otherwise derive from `$PWD` and `$HOME` with three mutually exclusive branches:
   - `$PWD == $HOME` → `core`
   - parent of `$PWD == $HOME` → `core-{current_dir}`
   - otherwise → `{parent}-{current_dir}`, where `{parent}` is the mapped prefix from `ZSH_HERDR_PARENT_PREFIX_MAP` when the raw parent directory name has a non-empty entry, or the full parent directory name otherwise.
3. Sanitize (slugify) the whole assembled name: replace every non-alphanumeric character with `-`; collapse each run of consecutive `-` into one; strip leading and trailing `-`; lowercase. The collapse runs BEFORE the edge strip, so `---x---` yields `x`, not `--x--`.

### Parent prefix map

`ZSH_HERDR_PARENT_PREFIX_MAP` is a newline-separated list of `parent=prefix` pairs (newline-delimited, not space/comma, because parent directory names may contain spaces). Default: `codiplab=cl`, `luismayta=lm`, `hadenlabs=hdx`.

- The substitution applies ONLY in the third branch (`{parent}-{dir}`) and ONLY against the RAW parent directory name, before slugification.
- A parent with no entry in the map keeps its full name, so projects outside CodipLabs are unaffected: `/home/user/sideproject/tool` still derives `sideproject-tool`.

### Legacy-label lookup fallback

Workspace lookup tries the newly derived label first; if no workspace carries it, it falls back to the legacy `{parent_dir}-{current_dir}` label (derived with an empty map — the form used before the prefix map existed). A workspace found under either label is reused and never recreated.

Examples (assuming `$HOME=/home/user`, default map):

| PWD | Result |
|-----|--------|
| `/home/user` | `core` |
| `/home/user/proj` | `core-proj` |
| `/home/user/work/repo` | `work-repo` |
| `/home/user/codiplab/base-template` | `cl-base-template` |
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

Applied after workspace creation, once per tab (non-fatal — layout failures warn but do not abort).

`hrd::internal::pane::setup_3_pane_layout <ws_id> [num_tabs]` creates the tabs and applies the layout
below to each tab independently. `num_tabs` is optional and **defaults to 2 tabs**: `hrd::project` and
`hrdw::create` both call it without `num_tabs`, so every new workspace ends up with `<ws>:t1` and
`<ws>:t2`, each with its own 3-pane layout (the second tab is created with `herdr tab create` first).
After the last tab is laid out, focus returns to the first tab (`herdr tab focus <ws>:t1`).

Layout of each tab:

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
| `ZSH_HERDR_PARENT_PREFIX_MAP` | Newline-separated `parent=prefix` pairs consulted in the `{parent}-{dir}` branch only (default `codiplab=cl`, `luismayta=lm`, `hadenlabs=hdx`) |

## 9. Notes for the Rust implementation

- Replicate: name slugify rules (§3), attach-or-create semantics (§4 — never recreate an existing workspace), JSON field `.result.workspace.workspace_id`, and the exact pane split/rename sequence (§6).
- The 3-pane layout must be idempotent per creation: it runs only on a freshly created workspace.
- Preserve exit-code semantics (§2): `0` = done (attached, created, or declined), `1` = hard failure.
- `--cwd` must be the invocation directory of the original command, not the Rust binary's cwd.
---
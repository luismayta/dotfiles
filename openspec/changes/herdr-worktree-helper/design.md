## Context

The herdr Zsh module at `zsh/modules/herdr/` provides workspace management through a layered architecture:

```
plugin.zsh → config/main.zsh → internal/main.zsh → pkg/main.zsh
```

- **`internal/base.zsh`** — low-level helpers: `hrd::internal::list_workspaces`, `switch_workspace`, `kill_workspace`, `fzf_select`, `derive_project_name`, plugin management
- **`pkg/helper.zsh`** — user-facing functions: `hrd()` (fzf workspace selector), `hrdk()` (fzf workspace killer), `hrd::project()` (3-pane IDE layout), `hrd::plugin()` (plugin manager)
- **`pkg/alias.zsh`** — currently has `alias hrd=herdr` which shadows the `hrd()` function from `helper.zsh`
- **`_hrd()`** — wrapper in `helper.zsh` that calls `command herdr "$@"`, used internally

The binario `herdr` (agent multiplexer, https://herdr.dev) natively supports `worktree` as a top-level subcommand:

- `herdr worktree list [--workspace ID | --cwd PATH] [--json]`
- `herdr worktree create [--workspace ID | --cwd PATH] [--branch NAME] [--base REF] [--path PATH] [--label TEXT] [--focus] [--no-focus] [--json]`
- `herdr worktree open [--workspace ID | --cwd PATH] (--path PATH | --branch NAME) [--label TEXT] [--focus] [--no-focus] [--json]`
- `herdr worktree remove --workspace ID [--force] [--json]`

Worktrees are normal herdr workspaces with Git checkout provenance. Checkouts are stored under `<worktrees.directory>/<repo>/<branch-slug>`.

The module already has a well-established pattern for workspace helpers (`hrd`, `hrdk`) that the worktree helper should follow.

## Goals / Non-Goals

**Goals:**

- Expose `herdr worktree` operations through a family of `hrdw::*` subcommand functions following the `hrd::project`/`hrd::plugin` namespace pattern and the `hrd`/`hrdk` short-prefix convention
- Provide fzf-based worktree navigation (list → select → open)
- Support worktree creation from current directory with optional branch name
- Handle errors: non-git directory, existing worktree, dirty checkout
- Resolve the existing `alias hrd=herdr` / `hrd()` function shadowing conflict
- All new functions follow existing herdr module conventions (namespacing, file placement, sourcing)

**Non-Goals:**

- Not a general git worktree manager — only wraps `herdr worktree` subcommands
- No changes to the herdr binary or its configuration
- No changes to existing `hrd`, `hrdk`, `hrd::project`, or `hrd::plugin` behavior (except alias fix)
- No support for worktree `remove` at the user-facing helper level (focus on create/list/open)

## Decisions

### D1: Function naming — `hrdw::*` subcommand family

**Decision:** Expose the worktree helper as a family of functions named `hrdw::create`, `hrdw::list`, `hrdw::open`, `hrdw::remove`, following the existing namespace pattern `hrd::project`, `hrd::plugin`, `hrd::internal::*`. The prefix `hrdw` (short for "herdr worktree") identifies the domain; the subcommand suffix determines the operation.

**Rationale:** Using `::` for subcommands is more scalable than flags or positional arguments — adding new operations (`hrdw::info`, `hrdw::prune`, etc.) requires no refactoring of dispatch logic. It's consistent with the module's existing `hrd::project::*` and `hrd::plugin::*` patterns, and it makes each subcommand discoverable via `which hrdw::create` or tab completion.

**Alternatives considered:**
- `hrdw <branch>` — concise but doesn't extend to `remove`, `list`, `open` without flags or position-based dispatch
- `hrdw` with flags (`--create`, `--list`) — error-prone, flags obscure the action
- `hrd-worktree` + flags — too long, breaks the short-command pattern
- `herdr-worktree` — defeats the purpose of a short helper

### D2: Internal namespace — `hrd::internal::worktree::*`

**Decision:** Worktree internal functions live in `internal/base.zsh` under the `hrd::internal::worktree::` namespace.

**Proposed functions:**
- `hrd::internal::worktree::list` — calls `herdr worktree list --cwd . --json`, parses output
- `hrd::internal::worktree::create <branch>` — calls `herdr worktree create --cwd . --branch <name> --focus`
- `hrd::internal::worktree::open <path|branch>` — calls `herdr worktree open --path <path> --focus`
- `hrd::internal::worktree::remove <workspace-id>` — calls `herdr worktree remove --workspace <id>` with optional `--force`
- `hrd::internal::worktree::is_git_repo` — checks `git rev-parse --git-dir`
- `hrd::internal::worktree::derive_repo_name` — extracts repo name from `git remote get-url origin`
- `hrd::internal::worktree::branch_exists <branch>` — checks output of `herdr worktree list --json` for an existing worktree on the given branch
- `hrd::internal::worktree::fzf_select` — wraps `hrd::internal::fzf_select` with worktree-specific preview (shows branch, path, status)

**Rationale:** Follows the existing `hrd::internal::*` namespace convention. The `worktree::` sub-namespace groups worktree-related functions separately from workspace functions.

**Alternatives considered:**
- `hrd::internal::worktree_*` — flat namespace, but `::` sub-namespace is more consistent with how `plugin::` is used in `herdr::internal::plugin::*`

### D3: Alias conflict resolution — remove alias, enhance `hrd()` function

**Decision:** Remove `alias hrd=herdr` from `pkg/alias.zsh` and modify the `hrd()` function in `pkg/helper.zsh` to forward unrecognized arguments to `_hrd()`.

**Current behavior (broken):**
- `alias hrd=herdr` in `alias.zsh` (sourced LAST) shadows the `hrd()` function
- Typing `hrd` runs `herdr` (no args) instead of the workspace selector

**New behavior:**
- `hrd` (no args) → fzf workspace selector (existing logic)
- `hrd my-workspace` → switch to workspace (existing logic)
- `hrd workspace list` or `hrd worktree create --branch foo` → forward to `_hrd "$@"` (new)

**Implementation:**
```zsh
function hrd {
  if [[ $# -eq 0 ]]; then
    # ... existing workspace selector via fzf ...
  elif [[ "$1" =~ ^(workspace|session|server|plugin|worktree|completion|update|status|api|tab|pane|agent|wait|notification|integration|terminal)$ ]]; then
    _hrd "$@"
  else
    hrd::internal::switch_workspace "$1"
  fi
}
```

**Rationale:** The alias provides no value — it makes `hrd` always equal `herdr`, defeating the purpose of the `hrd()` helper function. The enhanced function preserves backward compatibility for existing usage (both `hrd` with no args and `hrd <workspace-name>`) while adding full herdr passthrough for subcommands.

**Alternatives considered:**
- Keep alias, rename function — breaks existing usage of `hrd()` as workspace selector
- Keep both with `noglob` / `alias hrd=hrd' '` tricks — fragile, non-obvious
- Use `precmd` to unalias — breaks the moment alias.zsh is re-sourced

### D4: fzf reuse — use existing `hrd::internal::fzf_select`

**Decision:** The worktree navigation subcommand `hrdw::open` reuses the existing `hrd::internal::fzf_select` function from `internal/base.zsh` for interactive selection. The internal wrapper `hrd::internal::worktree::fzf_select` configures worktree-specific options (prompt text, preview command showing branch/path/status).

**Preview:** Show worktree info (branch, path, workspace status) in the fzf preview window.

**Rationale:** Avoids duplicating fzf setup logic. The existing function already handles prompt, preview, and error cases.

### D5: Git repo detection — use `git rev-parse --git-dir`

**Decision:** Before running any `herdr worktree` command, check if the current directory is inside a git repository.

```zsh
function hrd::internal::worktree::is_git_repo {
  git rev-parse --git-dir &>/dev/null
}
```

**Rationale:** `herdr worktree` silently fails or creates unexpected workspaces when called outside a git repo. Early failure with a clear message is better UX.

### D6: Branch prefix — auto-prepend `feature/` when creating

**Decision:** When creating a worktree with `hrdw::create <name>`, if the name does not start with a prefix (`feature/`, `fix/`, `bugfix/`, `hotfix/`, `chore/`), the function automatically prepends `feature/`.

**Example:** `hrdw::create RD-21` → branch `feature/RD-21`. `hrdw::create hotfix/login-bug` → branch `hotfix/login-bug` (no change).

**Rationale:** Common workflow is to create feature branches for Jira tickets or short identifiers. Auto-prefixing reduces keystrokes and enforces consistent branch naming. The prefix list covers the standard git-flow convention.

**Alternatives considered:**
- No prefix — user types `feature/RD-21` explicitly. ✅ Fully supported (any name with a prefix is passed through as-is).
- Always prompt for prefix — adds friction for the common case.

## Risks / Trade-offs

- **[Risk] `hrd` passthrough might hide typos**: If a user types `hrd workspce list` instead of `hrd workspace list`, the pattern match fails and it falls through to workspace switch with name "workspce" + ignores rest. **Mitigation**: only match known subcommands explicitly.
- **[Risk] Existing users who rely on `alias hrd=herdr`**: If someone uses `hrd` as a full alias for `herdr` (e.g., `hrd status`, `hrd session list`), removing the alias breaks those commands. **Mitigation**: the enhanced `hrd()` function forwards all known subcommands to `_hrd`.
- **[Risk] Tab completion**: Removing the alias might break shell completion for `hrd`. **Mitigation**: `herdr completion zsh` generates a `_herdr` completion function. Users who want completion for `hrd` can alias it separately in their `.zshrc`.
- **[Trade-off] `hrdw` is git-context-dependent**: Unlike `hrd` (which works anywhere), `hrdw` only works inside git repos. This is inherent to the worktree domain.

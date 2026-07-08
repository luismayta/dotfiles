## 1. Resolve Alias Conflict

- [x] 1.1 Remove `alias hrd=herdr` from `pkg/alias.zsh`
- [x] 1.2 Enhance `hrd()` function in `pkg/helper.zsh` to forward herdr subcommands to `_hrd()` — add dispatch logic: if `$# -eq 0` run fzf selector, elif `$1` is a known herdr subcommand call `_hrd "$@"`, else call `hrd::internal::switch_workspace "$1"`
- [x] 1.3 Source `pkg/helper.zsh` BEFORE `pkg/alias.zsh` in `pkg/main.zsh` (verify: currently helper.zsh is sourced before alias.zsh — already correct)
- [x] 1.4 Verify: `hrd` (no args) launches fzf workspace selector; `hrd workspace list` runs `herdr workspace list`; `hrd my-workspace` switches to workspace

## 2. Add Internal Worktree Functions

- [x] 2.1 Add `hrd::internal::worktree::is_git_repo` to `internal/base.zsh` — checks `git rev-parse --git-dir &>/dev/null`
- [x] 2.2 Add `hrd::internal::worktree::derive_repo_name` to `internal/base.zsh` — extracts repo name from `git remote get-url origin`, used for display/branch-slug
- [x] 2.3 Add `hrd::internal::worktree::list` to `internal/base.zsh` — calls `herdr worktree list --cwd . --json`, parses output, formats as `branch | path | status` table
- [x] 2.4 Add `hrd::internal::worktree::create <branch>` to `internal/base.zsh` — calls `herdr worktree create --cwd . --branch <name> --focus`, handles existing worktree detection via `hrd::internal::worktree::branch_exists`
- [x] 2.5 Add `hrd::internal::worktree::branch_exists <branch>` to `internal/base.zsh` — checks output of `herdr worktree list --json` for an existing worktree on the given branch
- [x] 2.6 Add `hrd::internal::worktree::open <path|branch>` to `internal/base.zsh` — calls `herdr worktree open --path <path> --focus` with the selected worktree's path
- [x] 2.7 Add `hrd::internal::worktree::remove <workspace-id> [--force]` to `internal/base.zsh` — calls `herdr worktree remove --workspace <id>` with optional `--force`
- [x] 2.8 Add `hrd::internal::worktree::fzf_select` to `internal/base.zsh` — wraps `hrd::internal::fzf_select` with worktree-specific preview (branch/path/status)

## 3. Add User-Facing hrdw::* Subcommand Functions

- [x] 3.1 Add `hrdw::list()` to `pkg/helper.zsh` — lists worktrees via `hrd::internal::worktree::list`; guards: is_git_repo
- [x] 3.2 Add `hrdw::create()` to `pkg/helper.zsh` — creates worktree with branch auto-prefixing (`feature/`):
      - `hrdw::create RD-21` → branch `feature/RD-21`, calls `hrd::internal::worktree::create feature/RD-21`
      - `hrdw::create hotfix/login-bug` → branch `hotfix/login-bug` (passthrough, no prefix)
      - `hrdw::create` (no args) → show usage: "Usage: hrdw::create <branch-name>"
      - Guard: existing-worktree detection before creation, offer to open instead
- [x] 3.3 Add `hrdw::open()` to `pkg/helper.zsh` — opens worktree by fzf or by branch:
      - `hrdw::open` → fzf selector via `hrd::internal::worktree::fzf_select`
      - `hrdw::open RD-21` → auto-prefix → resolve path → open via `hrd::internal::worktree::open`
- [x] 3.4 Add `hrdw::remove()` to `pkg/helper.zsh` — removes worktree by fzf or by id:
      - `hrdw::remove <workspace-id>` → remove via `hrd::internal::worktree::remove <id>`
      - `hrdw::remove` → fzf selector → confirm prompt → remove
      - Guard: dirty checkout message with `--force` hint
- [x] 3.5 All `hrdw::*` functions call `hrd::internal::worktree::is_git_repo` first; print error and return 1 if not in a git repo
- [x] 3.6 Verify: `hrdw::list` shows worktrees; `hrdw::create RD-21` creates `feature/RD-21`; `hrdw::open` shows fzf; `hrdw::remove <id>` removes

## 4. Verify Module Loading

- [ ] 4.1 Source `plugin.zsh` and confirm `hrdw::create`, `hrdw::list`, `hrdw::open`, `hrdw::remove` are available as shell functions
- [ ] 4.2 Confirm `hrd` resolves to the function (not the alias) and workspace selector works
- [ ] 4.3 Confirm `hrd worktree list` passes through to `herdr worktree list`
- [ ] 4.4 Confirm `hrd workspace list` passes through to `herdr workspace list`
- [x] 4.5 Run `shellcheck` on modified files for common Zsh issues

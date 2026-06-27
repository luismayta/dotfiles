## Context

The `zsh/modules/scmbreeze/` module wraps the external [SCM Breeze](https://github.com/scmbreeze/scm_breeze) tool. It provides:

1. **Numbered file shortcuts** — `git status` output with numeric indices (e.g., `1`, `2`, `3`) to reference files in `git add`, `git diff`, etc.
2. **Git aliases** — shorthand commands like `gs` (status), `ga` (add), `gd` (diff), `gA` (add all), etc.

The `zsh/modules/git/` module already provides:

- **scmpuff** — A Rust-based tool that provides identical numbered file shortcuts (`gs`, `ga`, `gd`, `gA`, file indexing with `1`, `2`, `3`). Already initialized in `git/internal/main.zsh` via `scmpuff::internal::load`.
- **Git aliases** — Defined in `git/pkg/alias.zsh` covering common commands: `g`, `gl`, `gp`, `gc`, `gca`, `gb`, `gco`, `glog`, `gwip`, `gunwip`, `gf`, etc.

The scmbreeze module is auto-discovered by `zsh/zshrc` via the `modules/*/` loop. Removing the directory from the modules folder is sufficient to disable it — no changes to zshrc are needed.

## Goals / Non-Goals

**Goals:**
- Port any missing git aliases from SCM Breeze conventions into `git/pkg/alias.zsh`
- Remove the entire `zsh/modules/scmbreeze/` directory
- Ensure zero regressions in the user's daily git workflow

**Non-Goals:**
- Replicate SCM Breeze's `git status` formatting or custom `git config` changes — scmpuff already handles the numbered file shortcut use case natively
- Preserve the `scmbreeze::*` public API functions — they will be removed with the module
- Preserve `~/.scm_breeze/` installation — it becomes orphaned and can be cleaned up manually

## Decisions

1. **scmpuff stays** — Already integrated into the git module, provides the exact same `gs`/`ga`/`gd`/`gA` plus file indexing that SCM Breeze provided. No changes needed to scmpuff integration.

2. **Add SCM Breeze aliases not conflicting with scmpuff to `pkg/alias.zsh`** — Standard SCM Breeze aliases not yet present in the git module:
   - `gst` = `git stash`
   - `gfa` = `git fetch --all`
   - `gm` = `git merge`
   - `grm` = `git rm`
   - `gcp` = `git cherry-pick`
   - `gbl` = `git blame`

   Aliases `gs`, `ga`, `gd`, `gA` are already provided by scmpuff, so no alias definitions needed.

3. **Module removal via directory deletion** — The zshrc auto-discovers modules; no registration/deregistration config needed. Removing the directory is the cleanest removal.

4. **No cleanup of `~/.scm_breeze/` in automation** — This is a user data directory. Documented as optional manual step post-migration.

## Risks / Trade-offs

- **[Alias collision risk]** Some users may have SCM Breeze aliases in muscle memory that conflict with existing git module aliases. → All added aliases will be checked against the existing `alias.zsh` to avoid duplicates.
- **[Missing alias risk]** If the user relied on a less common SCM Breeze alias not listed above, it will be lost. → The migration adds the most common ones; any missing can be added post-migration.

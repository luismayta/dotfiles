## Context

The dotfiles repository includes git-flow integration across the `zsh/modules/git/` and `zsh/modules/issues/` modules. Git-flow provided branch management (develop/master), feature helpers (`gff`), workflow detection, and package installation (`git-flow` / `gitflow-avh`). The team has standardized on GitHub Flow — all work uses short-lived feature branches off `main` with no `develop` branch. All git-flow code is dead code.

The current state is the result of gradually migrating away from git-flow over multiple changes (archived: `git-flow-paru-fix`, `migrate-zsh-git`, `migrate-zsh-external-modules`), but remnants remain across modules.

## Goals / Non-Goals

**Goals:**
- Remove all git-flow code paths from `zsh/modules/git/`
- Remove all git-flow code paths from `zsh/modules/issues/`
- Remove git-flow from package installation/ensuring
- Ensure `issues/` workflow falls through cleanly to the default (non-gitflow) path
- Remove `docs/contribute/github-flow.md` comparative reference

**Non-Goals:**
- No refactoring of non-gitflow code paths (they already work)
- No changes to GitHub Flow behavior or branch naming conventions
- No changes to makefile, CI, or git hooks (git-flow was not referenced there)

## Decisions

### 1. Remove vs. comment out — remove entirely
Dead code should be deleted, not commented. If git-flow is ever needed again, git history provides full recovery. Removing dead code eliminates maintenance burden and test surface.

### 2. Workflow fallback — default to non-gitflow path
In `issues/internal/base.zsh`, the workflow detection currently checks: (a) `gitflow.branch.master` git config, (b) `.gitflow` / `gitflow.toml` file existence. After removal, the `$workflow` variable defaults to an empty string, which maps to the existing "standard" (non-gitflow) branch detection path. No new default needs to be introduced.

### 3. `gff` helper — delete entirely
The `gff` function in `pkg/base.zsh` wraps `git flow feature`. Without git-flow installed, this function would error. Since it was the only user-facing helper for git-flow, it's removed.

### 4. `git::internal::gitflow::branch::develop` / `::master` — delete
These functions read `git config --local gitflow.branch.*`. They were consumed in `internal/base.zsh` line 155 (branch name comparison) and line 204 (checkout). After removal, those call sites use standard branch logic from the GitHub Flow path.

## Risks / Trade-offs

- **[Risk]** A dependent zsh function may still reference a removed gitflow function.
  → **Mitigation**: The KenThompson search confirmed all callers are within the same files being modified. No external consumers.
- **[Risk]** Users with active git-flow initialized repos may experience breakage.
  → **Mitigation**: This is a personal dotfiles repo. No other users. The owner confirmed git-flow is unused.
- **[Risk]** The `core::ensure` call for git-flow in `internal/main.zsh` might be the last reference keeping other ensures in order.
  → **Mitigation**: Removing `core::ensure "${GIT_FLOW_PACKAGE_NAME:-git-flow}"` removes one entry from the ensure list; other ensures (git, hub, rsync) are independent and unaffected.
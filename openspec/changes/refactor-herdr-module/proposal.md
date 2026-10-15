# Proposal

## Why

The `zsh/modules/herdr/` module works, but it is hard to change safely: 40 files and 2622 lines with zero tests, a 390-line `pkg/helper.zsh` holding five unrelated concerns, and `bin/hrdw-*` re-implementing worktree logic in bash under the same user-facing names but a different backend — so the same command can return a different result depending on how it is invoked. On top of that, workspace labels are derived by an algorithm that produces `{parent_dir}-{current_dir}` (e.g. `codiplab-myproject`), a function that exists near-verbatim twice (`internal/base.zsh` and `zsh/modules/tmux/internal/base.zsh`, byte-identical logic bodies), and the git-flow branch prefix chain is copy-pasted in four places.

None of this is theoretical friction: `herdr-project.md` §6 claims a single 3-pane tab while the code and the `pane-layout` spec both say 2, so documentation and reality disagree; the only test runner in the neighborhood (`zsh/modules/git/tests/run.sh`) globs `*.bats` in a repo with no `.bats` files and exits 1 today; and neither pre-commit nor CI runs `zsh -n`, so a syntax error in any module file ships silently. Fixing any one problem in isolation would either break the others or be unverifiable. This proposal makes the module maintainable in one ordered change, with a test net first so the one behavior change lands on a safety harness instead of on faith.

## What Changes

Four ordered phases. Order is non-negotiable: each phase must leave the module's tests green before the next begins. Phase 2 changes observable workspace-label format and needs Phase 1's net to catch regressions; Phase 3 touches the same files as Phase 2, so it follows rather than running in parallel.

- **FASE 1 — Test net.** Create `zsh/modules/herdr/tests/` following the `zsh/modules/git/tests/run.sh` precedent: an executable bats runner plus a `test` target in the module `Taskfile.yml`. Touches no production code.
- **FASE 2 — Naming.** Replace the derived `{parent_dir}-{current_dir}` label with an explicit `parent_dir -> prefix` map declared in config, with the full parent name used when no entry matches (preserving behavior for projects outside CodipLabs) and a lookup that tries the new label first, then the legacy label so already-created workspaces are never recreated. Extract derivation into a single helper shared by herdr and tmux. The only phase that changes observable behavior.
- **FASE 3 — Restructure.** Split `pkg/helper.zsh` into cohesive modules, unify `bin/` with `pkg/helper.zsh` onto one backend and one naming derivation, and normalize the coexisting `hrd::` / `herdr::` namespaces. Purely structural, zero observable behavior change.
- **FASE 4 — Hygiene.** Fix `herdr-project.md` to match the code — the code stays at 2 tabs; this is documentation reconciliation, not a behavior change. Remove dead code and the dead `ZSH_HERDR_WORKSPACE_PREFIX` hook, normalize indentation to `.editorconfig`, and add a `zsh -n` syntax check to pre-commit and CI.

This change MODIFIES the existing, un-archived `herdr-worktree-helper` change (19/23 tasks done, code already landed in `pkg/helper.zsh` and `internal/worktree.zsh`) rather than archiving it or forking a near-duplicate capability.

## Capabilities

### New Capabilities

- `workspace-naming`: The durable rules for deriving a workspace label from directory context — the three derivation branches (PWD==HOME yields `core`; parent==HOME yields `core-{dir}`; otherwise `{parent}-{dir}`), slug normalization rules, the explicit parent-directory prefix map with full-name fallback, the legacy-label lookup fallback for pre-existing workspaces, and the single shared source of truth consumed by both herdr and tmux.
- `herdr-test-suite`: The module's regression safety net — an executable bats runner plus a `test` target in `zsh/modules/herdr/Taskfile.yml`, coverage of the naming derivation branches, slug edge cases (non-alphanumeric, repeated/leading/trailing hyphens, uppercase, spaces, dots, non-ASCII), and `hrd::project` exit codes against a mocked `herdr`; plus a `zsh -n` syntax check over every module `.zsh` in both pre-commit and CI.

### Modified Capabilities

- `herdr-worktree-helper`: The "Module integration" requirement pins public API to `pkg/helper.zsh` and internal logic to `internal/base.zsh`; Phase 3 splits those files, so the requirement must change. The worktree label format becomes `{project_context}/{branch_leaf}` on both the zsh and bash sides, and the internal namespace convention becomes a single chosen form.
- `internal-module-structure`: Currently declares one file per domain for `internal/` only, and lists `list_templates`, `select_template`, and `worktree::derive_repo_name` as part of the inventory. Phase 3 extends the same domain-separation discipline to `pkg/`, and Phase 4 removes the dead functions from the declared inventory.
- `herdr-cli`: Currently specifies `hrdw-create`, `hrdw-list`, `hrdw-delete` as standalone CLIs. Phase 3 resolves the duplicate worktree logic so `bin/` either delegates to `pkg/` or is removed with the replacement documented, and so both sides use one backend and one naming derivation including slugify, the `core` prefix, and the parent-folder prefix.

## Impact

**Affected code**

- `zsh/modules/herdr/**` — all four phases live here; the largest edits are the `pkg/helper.zsh` split and the `bin/` unification.
- `zsh/modules/tmux/internal/base.zsh` — its near-clone of the derivation function is replaced by the shared helper; tmux behavior must remain observably unchanged.
- `zsh/system/**` — home of the shared derivation helper.
- The four call sites of the naming function inside `pkg/helper.zsh` (lines 105, 277, 342, 377) all move with the split and must resolve to the new shared helper.

**Public API that must stay stable**: `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `hrd::plugin`, `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`, `edit-herdr-config`, `edit-herdr-plugins`.

**Tooling**: `zsh/modules/herdr/Taskfile.yml` gains a `test` target; `.pre-commit-config.yaml` and `.github/workflows/lint.yml` gain the `zsh -n` check (both currently run shellcheck only); `.editorconfig`'s 2-space `[*]` rule becomes actually enforced instead of aspirational. New test dependency: `bats`.

**Blast radius is low.** A repo-wide search found zero non-documentation callers of `hrd::`, `herdr::internal::`, `hrdw::`, `derive_project_name`, or `derive_repo_name` outside the herdr module — only prose in `docs/`, `openspec/`, and `.codi/`. The observable-behavior surface is therefore limited to workspace labels: Phase 2 changes them for new workspaces, and the legacy-label fallback guarantees existing workspaces keep resolving.

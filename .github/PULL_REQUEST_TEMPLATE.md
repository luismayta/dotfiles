## Proposed changes

Describe the big picture of your changes here to communicate to the maintainers why we should accept this pull request. If it fixes a bug or resolves a feature request, be sure to link to that issue.

## Types of changes

What types of changes does your code introduce to Project? _Put an `x` in the boxes that apply_

- [] Bugfix (non-breaking change which fixes an issue)
- [] New feature (non-breaking change which adds functionality)
- [] Breaking change (fix or feature that would cause existing functionality to not work as expected)

## Checklist

_Put an `x` in the boxes that apply. You can also fill these out after creating the PR. If you're unsure about any of them, don't hesitate to ask. We're here to help! This is simply a reminder of what we are going to look for before merging your code._

- [] I have read the [CONTRIBUTING](/docs/contributing.md) doc
- [] Lint and unit tests pass locally with my changes
- [] I have added tests that prove my fix is effective or that my feature works
- [] I have added necessary documentation (if appropriate)
- [] Any dependent changes have been merged and published in downstream modules

## Further comments

If this is a relatively large or complex change, kick off the discussion by explaining why you chose the solution you did and what alternatives you considered, etc...

## Observable deltas — `refactor-herdr-module` Phase 3 (`bin/` carve-out)

Phase 3 claims zero behavior change; these five deltas are the sanctioned exception (design Risk 1). They are the observable-behavior changes of the `bin/hrdw-*` unification and must be reviewed and release-noted as a set:

1. `hrdw-create` moves where worktrees land on disk (herdr-managed location vs the raw `git worktree` path) and gains workspace-create/focus/layout side effects it never had.
2. `hrdw-list` narrows from all git worktrees to herdr-managed worktrees.
3. `hrdw-delete <workspace-id>` starts working as documented (it previously grepped `git worktree list` for a workspace id, which never appears there).
4. `hrdw-create` with no arguments now exits **1** (the old bash script exited 0). This was required for function-parity with `hrdw::create`.
5. `hrdw-create --help` now prints help; previously it treated `--help` as a branch name and attempted to create `feature/--help`.

Sixth delta, found during the namespace rename (task 3.8 — not part of the `bin/` carve-out, listed here for completeness):

6. User-visible usage/error strings that name module functions now print the new `hrd::` namespace — e.g. `Usage: hrd::internal::plugin::install <owner/repo>` and `espresso CLI not found — run hrd::espresso::install first`; both previously carried the retired prefix.

---

## Duplication accounting — `refactor-herdr-module` Phase 4 (task 4.9)

**Method.** Pre-change content was read with `git show HEAD:<path>`, post-change content from the working tree; every figure below was recomputed from git in this checkout and none is copied from `design.md`, `tasks.md`, or the task brief (where a brief figure disagrees with git — e.g. the claimed "374-line" `pkg/helper.zsh` — git's count is the one reported). Two measurements are kept separate because they measure different things:

- **Ledger A — "lines of duplicated FILE content"**: whole-file `wc -l` before vs after, over five *disjoint* files. Only this ledger may be summed.
- **Ledger B — "lines of duplicated LOGIC"**: a named snippet counted as *copies × lines per copy*, before → after. Those snippets physically sit inside files already counted in Ledger A, so Ledger B must **not** be added to Ledger A.

### Ledger A — file-content lines (additive)

```console
$ for p in zsh/modules/herdr/bin/hrdw-create zsh/modules/herdr/bin/hrdw-delete \
           zsh/modules/herdr/bin/hrdw-list zsh/modules/tmux/internal/base.zsh \
           zsh/modules/herdr/pkg/helper.zsh; do
    b=$(git show HEAD:"$p" | wc -l); a=$([ -e "$p" ] && wc -l < "$p" || echo 0)
    printf '%-45s %4d %4d %+4d\n' "$p" "$b" "$a" "$((a-b))"
  done
zsh/modules/herdr/bin/hrdw-create                 163   48 -115
zsh/modules/herdr/bin/hrdw-delete                 187   46 -141
zsh/modules/herdr/bin/hrdw-list                   125   43  -82
zsh/modules/tmux/internal/base.zsh                148  129  -19
zsh/modules/herdr/pkg/helper.zsh                  390    0 -390
```

| file group | HEAD | now | delta |
| --- | ---: | ---: | ---: |
| `bin/` three CLIs (subtotal) | 475 | 137 | **−338** |
| `zsh/modules/tmux/internal/base.zsh` | 148 | 129 | **−19** |
| `zsh/modules/herdr/pkg/helper.zsh` | 390 | 0 | **−390** |
| **total (5 disjoint files)** | **1013** | **266** | **−747** |

−747 is the only additive total on this page and the only figure with no double counting. It is *file content*, not pure duplication: it also counts help text, doc comments and reorganisation, so treat it as an upper bound.

### Ledger B — duplicated logic, per category

| # | Category | Measured before → after | Duplicated lines removed | Overlap |
| --- | --- | --- | --- | --- |
| 1 | `bin/` re-implementations | 3 bash CLIs with raw `git worktree` logic, own naming and prefix/label assembly: **475 → 137** file lines (now thin delegators that re-enter zsh) | **−338** file lines | owns the `bin/` side of rows 3 and 4 (see below) |
| 2 | tmux derivation clone | `tx::internal::derive_project_name` spans `base.zsh:37–64` = **28 lines** (26-line body) → `base.zsh:43–45` = **3 lines** delegating to `core::workspace::derive_name` (`zsh/system/core/pkg/helper/workspace.zsh:22–73`, 52 lines) | **−25** lines (file net −19: `git diff --stat` = +7/−26, i.e. +6 doc lines above the delegator) | this *is* the tmux file's −19 in Ledger A |
| 3 | git-flow prefix chain | `git grep -n '\[\[ "$[a-z_]*" != feature/\* \]\]' HEAD -- zsh/modules/herdr` → **4 copies × 8 lines = 32 → 1 copy** (10-line `ensure_branch_prefix`, `internal/worktree.zsh:18–27`, plus a 7-line doc comment). Copies: `bin/hrdw-create:114–121`, `bin/hrdw-delete:174–181`, `pkg/helper.zsh:266–273` (`hrdw::create`), `pkg/helper.zsh:331–338` (`hrdw::open`) | **24 lines** (3 redundant copies × 8); net for the snippet 32 → 10 = −22 | 16 of the 32 lines sit inside row 1's −338, 16 inside row 6's −390 |
| 4 | worktree label `{project_context}/{branch_leaf}` | 6 assembly sites at HEAD, not 3: module side 3 (`pkg/helper.zsh:276–279`, `341–344`, `376–379` — design D4's "3 places") **and** `bin/` side 3 (`bin/hrdw-create:64–66` path variant, `124–127` label, `bin/hrdw-delete:86–90` prompt) → **1** (`derive_label`, `internal/worktree.zsh:43–49`, 7 lines + 13-line doc) | **8 lines** module side (2 sites × 4); the 3 `bin/` sites are inside row 1's −338 | the module's 12 assembly lines sit inside row 6's −390 |
| 5 | dead code (0 callers) | `derive_repo_name` `internal/worktree.zsh:11–22` = 12 lines; `list_templates` `internal/base.zsh:69–93` = 25 (4 doc + 21 body); `select_template` `internal/base.zsh:95–119` = 25 (3 doc + 22 body) → all three deleted | **−62 lines** (55 function-body + 7 doc-comment lines) | none — these live in `internal/`, no other row's file |
| 6 | monolith `pkg/helper.zsh` | **390 lines / 12 definitions** (`_hrd`, `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `edit-herdr-config`, `edit-herdr-plugins`, `hrd::plugin`, `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`) → deleted; the 12 definitions now sit in five cohesive modules totalling **378 lines** (lifecycle 73/3 defs, project 57/2, config-editor 40/2, plugin 64/1, worktree 144/4) sourced by the 18-line `pkg/main.zsh` loader | **−390** file lines; **−12** for the split itself (390 → 378), this row is cohesion, not line reduction | the 390 include row 3's two helper-side prefix copies (16 lines) and row 4's three label sites (12 lines) |

Verification for row 5 (zero callers before, zero names after):

```console
$ git grep -n 'hrd::internal::worktree::derive_repo_name\|hrd::internal::list_templates\|hrd::internal::select_template' HEAD -- zsh/
HEAD:zsh/modules/herdr/internal/base.zsh:73:function hrd::internal::list_templates {
HEAD:zsh/modules/herdr/internal/base.zsh:98:function hrd::internal::select_template {
HEAD:zsh/modules/herdr/internal/base.zsh:108:    hrd::internal::list_templates \
HEAD:zsh/modules/herdr/internal/worktree.zsh:11:function hrd::internal::worktree::derive_repo_name {
```

(only definitions, plus one call site — `base.zsh:108` — that sits *inside* `select_template` itself; no external caller existed)

```console
$ grep -rn 'hrd::internal::worktree::derive_repo_name\|hrd::internal::list_templates\|hrd::internal::select_template' zsh/   # now
$ echo $?
1
$ grep -rn 'derive_repo_name\|list_templates\|select_template' zsh/   # bare names now
zsh/modules/tmux/internal/base.zsh:56:tx::internal::list_templates() {
zsh/modules/tmux/internal/base.zsh:80:tx::internal::select_template() {
zsh/modules/tmux/internal/base.zsh:85:    tx::internal::list_templates \
zsh/modules/tmux/pkg/helper.zsh:26:  selected_template="$(tx::internal::select_template)"
```

(the survivors are the tmux module's own `tx::` functions — a different module, out of scope for this change; the `hrd::` names have zero definitions and zero call sites)

### Why no single grand total

The six categories overlap by construction, so summing them would mislead:

- 16 prefix-chain lines (2 copies × 8) + 12 label lines sit inside row 1's −338 (`bin/`);
- 16 prefix-chain lines + 12 label lines sit inside row 6's −390 (`pkg/helper.zsh`);
- row 2's −25 is the same content as Ledger A's tmux −19.

That is **at least 56 lines claimed twice**, plus the whole tmux overlap. The per-category figures above are therefore the record; **no sum across rows 1–6 is given.** The only defensible aggregate is Ledger A's **−747 lines of file content across five disjoint files** (338 + 19 + 390), which is an upper bound on duplication removed rather than a pure duplication count.

Footnote (measured, deliberately not counted anywhere): a second derivation copy was collapsed in the same pass — `hrd::internal::derive_project_name` (`internal/base.zsh:41–67` = 27 lines → `57–59` = 3 lines, same `core::workspace::derive_name` delegator). It is not one of the six requested categories, so it is listed here and added to no figure.
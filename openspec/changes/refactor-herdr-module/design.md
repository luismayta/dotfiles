# Design

## Context

This change makes the `zsh/modules/herdr/` module safe to change: the motivation and problem statement live in `proposal.md` § Why and are not restated here. The requirements being satisfied are the five spec deltas in `specs/` (`workspace-naming`, `herdr-test-suite`, `herdr-worktree-helper`, `internal-module-structure`, `herdr-cli`) and the acceptance tests in `.codi/jira/RD-234/requirements/RD-234.md`. This document explains HOW the work is done and WHY these particular choices were made over the alternatives.

Two facts shape every decision below and are worth stating up front:

1. This change MODIFIES the existing, un-archived `herdr-worktree-helper` change (code already landed in `pkg/helper.zsh` and `internal/worktree.zsh`). We are not forking a near-duplicate capability or archiving the earlier change mid-flight.
2. The requirements contain one direct contradiction between requirement #25 (RD-234.md:81, "preserve every function namespace exactly, rename nothing") and requirement #31 (RD-234.md:87, "choose a single namespace convention across `internal/` and `pkg/`"). It is resolved explicitly as decision D0 below; nothing else in this design depends on unstated interpretation of those two lines.

## Goals / Non-Goals

**Goals:**

- One derivation implementation for workspace names, shared by herdr and tmux, with the explicit `parent_dir -> prefix` map and the legacy-label fallback (`specs/workspace-naming/`).
- One worktree backend (`herdr worktree`) behind both the zsh functions and the `bin/` CLIs, with identical label and name derivation on every invocation path (`specs/herdr-cli/`, `specs/herdr-worktree-helper/`).
- `pkg/helper.zsh` split into five cohesive files under the 150-line cap, with `pkg/main.zsh` sourcing them in a deterministic order (`specs/internal-module-structure/`).
- A single namespace convention across `internal/` and `pkg/`, with the frozen public API untouched.
- A real regression net: bats suite plus anti-vacuous runner guards, wired to `task test` and CI (`specs/herdr-test-suite/`).
- Dead `ZSH_HERDR_WORKSPACE_PREFIX` removed entirely — declaration and backward-compat re-export (RD-234.md requirement #14 forbids a declared hook nothing reads).

**Non-Goals:**

- No user migration. Behavior converges (new labels where the map applies, legacy fallback for existing workspaces); nothing breaks, nothing needs rewriting in `~/.customrc`.
- No module-wide enforcement of the 150-line cap. `internal/worktree.zsh` (163 lines) and `internal/install.zsh` (188 lines) already exceed it before this change; fixing those is separate Phase 4 hygiene work, not this split.
- No rename command for workspaces, no new user-facing features. The prefix map is the extension point if prefix behavior is ever needed again.
- No observable change in tmux. `tx::project` keeps producing byte-identical session names for every input.
- No behavior change in Phase 3 except the sanctioned `bin/` carve-out (see Risk 1).
- Not archiving `herdr-worktree-helper`; this change modifies it in place.

## Decisions

### D0 — Precedence: #25 binds the frozen public API and user-typed commands; #31 authorizes renaming `internal/` and non-frozen `pkg/` names.

Requirements #25 and #31 are contradictory if read as universal rules. They are reconciled as a scope split, and this precedence rule is binding for the rest of the review:

- **#25 binds the frozen set.** These names are preserved exactly, with zero renames: `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `hrd::plugin`, `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`, `edit-herdr-config`, `edit-herdr-plugins`. These are the names users type and the names the Phase-1 bats load smoke asserts via `whence -w`.
- **#31 authorizes renaming everything else.** All namespaced functions under `internal/` and `pkg/` that are NOT in the frozen set get renamed to the single chosen convention (D3). Commands `hrd`, `hrdk`, `edit-herdr-config`, `edit-herdr-plugins` are not namespaces and are exempt from namespace rules entirely.

Rationale: #25's intent is "the public API does not churn under users"; #31's intent is "stop the `hrd::`/`herdr::` coexistence." Read as scoped to their respective surfaces, both hold with zero exceptions. Read as universal, one must be discarded. The scoped reading discards nothing.

Alternative rejected: treating #25 as absolute. That would freeze ~25 `herdr::` definitions as permanent violations of the very convention #31 requires being written down, making #31 unimplementable and leaving the repo with a rule that its own module breaks on day one.

### D1 — Shared derivation helper: `core::workspace::derive_name` in `zsh/system/core/pkg/helper/workspace.zsh` (new).

File `zsh/system/core/pkg/helper/workspace.zsh` (new), function `core::workspace::derive_name [explicit-name] [prefix-map]`, using `function name {` syntax as mandated by `openspec/specs/function-name-validation/spec.md:5` (every namespaced function is defined as `function namespace::function {`).

**Why core.** The system layer is antidote/core/nix/nix-darwin, and only `core` is a dependency of both consumers: herdr already uses `core::exists` and `core::path::prepend`, tmux already uses `core::exists`. Placing the helper in either module would make the other depend on a peer module.

**Why `pkg/helper/` and not `internal/`.** `docs/guides/create-module.md:51` states the rule at line 51: "One layer never calls into another's `internal/` across module boundaries." herdr and tmux are separate modules, so neither may call the other's `internal/`. `pkg/helper/` is core's established home for helpers consumed outside core — `pkg/helper/backup.zsh`, `core.zsh`, and `tmux.zsh` already live there, sourced via `pkg/helper/main.zsh`.

**Why it always loads.** `zsh/zshrc:23` sources `core/main.zsh` unconditionally, BEFORE the modules loop at `zsh/zshrc:57` that loads herdr and tmux; core is explicitly skipped in that loop (`zsh/zshrc:30-32`) because it is loaded via `main.zsh`. Load chain: `core/main.zsh` → `pkg/main.zsh` (sources `pkg/helper/main.zsh` before `pkg/alias.zsh`) → `pkg/helper/main.zsh` → `pkg/helper/workspace.zsh`. The helper is defined before either consumer module loads.

**The prefix map is an argument, not a global.** The map is passed as `$2` and declared in `zsh/modules/herdr/config/base.zsh` as `ZSH_HERDR_PARENT_PREFIX_MAP`, newline-separated `parent=prefix` pairs. Newline (not space or comma) because parent directory names may contain spaces; a space- or comma-separated format is ambiguous for exactly the inputs slug normalization must handle. Default: `codiplab=cl`.

CRITICAL: passing the map as `$2` — rather than reading `ZSH_HERDR_PARENT_PREFIX_MAP` inside the helper — is what keeps tmux output byte-identical for every input, satisfying "no observable change in tmux" (requirement #19). If core read the global, tmux session names would change for any mapped parent (`codiplab-myproject` → `cl-myproject`), because tmux calls the same helper. With the map as an argument, tmux passes an empty map and gets the legacy derivation for every directory, by construction, not by discipline.

**Contract.**

| Input | Behavior |
|---|---|
| Non-empty `$1` | Used as the base name, slugified; map not consulted. |
| Empty `$1` | Runs the three existing branches (PWD==HOME → `core`; parent==HOME → `core-{dir}`; else `{parent}-{dir}`), consulting the map only in the third branch, and only for the parent component. |
| Empty `$2` | Byte-identical output to today's function, for every input. |

Purity: reads only `$1`, `$2`, `$PWD`, `$HOME`. No global mutation, no filesystem access, no side effects beyond the returned string (per `specs/workspace-naming/` "Derivation is pure").

**The legacy label is the same function with an empty map.** `core::workspace::derive_name "$1" ""` produces today's `{parent_dir}-{current_dir}` output. One implementation, both formats — the legacy label cannot drift from the new one because it is not a second implementation.

**Thin delegators in both modules.** herdr keeps `hrd::internal::derive_project_name` (passes `ZSH_HERDR_PARENT_PREFIX_MAP`); tmux keeps `tx::internal::derive_project_name` (passes `""`). Call sites in both modules are unchanged in shape.

**Alternatives rejected:**

| Alternative | Why rejected |
|---|---|
| `core/internal/` | Cross-module internal call, forbidden by `create-module.md:51`. |
| Helper reads the global map itself | Changes tmux session names for mapped parents; violates requirement #19. |
| Body stays in herdr, tmux calls it | tmux → herdr `internal/` call, forbidden; also inverts the dependency (tmux would depend on herdr). |
| A third copy in `bin/` | The duplication this change exists to remove. |

### D2 — Backend: `herdr worktree` wins. Raw `git worktree` is removed from the module.

**Decisive argument: `hrdw::open` and `hrdw::remove` already assume the herdr backend and cannot function on raw git.** `internal/worktree.zsh` resolves workspace ids via `herdr worktree list --json`, and `herdr worktree remove --workspace` takes a workspace id that a raw git worktree simply does not have. `hrdw::create` applies the 3-pane layout only because `herdr worktree create` produces a labeled workspace it can resolve afterward. Raw-git-winning is not a symmetric choice; it would require gutting open/remove, dropping layout integration, and rewriting the core requirements of the nearly-complete `herdr-worktree-helper` spec.

The zsh side is spec-backed: the `herdr-worktree-helper` spec mandates `herdr worktree ...` for create/list/open/remove, and this change MODIFIES that spec rather than superseding it. The bash side already violates its own `herdr-cli` requirement — `bin/hrdw-delete` greps `git worktree list` for a workspace id that never appears in git output, so delete-by-workspace-id is already broken in bash today.

**Shellcheck is a non-factor that tilts toward herdr.** `.pre-commit-config.yaml:147` excludes `bin/.*` from shellcheck entirely, so the raw-git code lives in the one directory never linted, while the zsh side is linted modulo already-excluded zsh-isms. Choosing herdr puts the canonical implementation on the linted side.

**Rot signal.** `bin/hrdw-create:125` contains `${PWD:t}`, a zsh-ism that is a `bad substitution` in bash, latent only because the fallback branch never evaluates. It is exactly the class of defect an unlinted duplicate accumulates.

### D3 — Namespace: `hrd::` wins. All namespaced functions in `internal/` and `pkg/` use `hrd::`.

**Primary argument: a convention that exempts the module's own frozen public API is not a convention.** The frozen set already contains seven namespaced `hrd::`/`hrdw::` names (D0). Choosing `herdr::` would leave all seven as permanent, load-bearing violations of the rule being written down. Choosing `hrd::` renames only unfrozen names and yields a rule with zero exceptions.

**Churn ratio favors `hrd::`.** Renaming `herdr::` → `hrd::` touches ~25 definitions and ~46 references. The reverse touches ~28 definitions and ~85 references plus spec and doc rewrites across `openspec/` and `docs/`.

**Short prefix is an established repo pattern.** `bitwarden` → `bw::`, `mobile` → `flutter::`.

**Corroboration, honestly weighted.** The existing `herdr-worktree-helper` design decision D2 already committed to `hrd::internal::worktree::*`. That is corroboration, not foundation: D2 was descriptive ("follows the existing convention") and could not alone settle a choice this change is explicitly being asked to make. The decision stands on the frozen public API argument; the earlier D2 is consistent with it.

**Commands are exempt.** `hrd`, `hrdk`, `edit-herdr-config`, `edit-herdr-plugins` are not namespaces; no rename applies.

**Rename mapping** (all definitions and all call sites, per D0's scope):

| File | Functions renamed |
|---|---|
| `internal/install.zsh` | `herdr::internal::install`, `config::sync`, `plugin::install`, `plugin::install::all`, `plugin::list`, `plugin::update`, `plugin::update::all`, `plugin::uninstall`, `deps::ensure`, `deps::install::${dep}` |
| `internal/update.zsh` | `herdr::internal::update` |
| `internal/osx.zsh`, `internal/linux.zsh` | `deps::install::espresso`, `espresso::daemon::install` |
| `pkg/base.zsh` | every `herdr::` wrapper (`herdr::install`, `herdr::update`, `herdr::sync`, `herdr::post_install`, `herdr::plugin::*`, `herdr::espresso::*`) |

**TRAP — dynamic string template.** `internal/install.zsh:181` builds one function name as a string: `installer="herdr::internal::deps::install::${dep}"`. Naive `function herdr::` greps miss it. Any cross-check MUST scan string literals, not just `function` definitions. The two `deps::install::espresso` definitions (`internal/osx.zsh`, `internal/linux.zsh`) must move in lockstep with this template or espresso auto-install fails silently behind its `ZSH_HERDR_ESPRESSO_ENABLED` guard.

**Acceptance check.** After the rename: `grep -r 'herdr::' zsh/modules/herdr` returns zero hits including comments; repo-wide `herdr::` returns only updated prose in `docs/guides/implement-module-update.md`.

**Alternative rejected:** `herdr::` — see primary argument; rejected also the status quo of coexistence, which is what #31 exists to end.

### D4 — The `pkg/helper.zsh` split.

**Correction to the requirements.** RD-234.md:22 states the file holds 10 functions; it actually holds **12** definitions: `_hrd`, `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `edit-herdr-config`, `edit-herdr-plugins`, `hrd::plugin`, `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`. Reviewers should expect 12, not 10.

**Mapping**, following the file's own five section headers (`pkg/helper.zsh:3-5`, `:75-77`, `:131-133`, `:170-172`, `:233-235`):

| Output file | Functions | ~Lines |
|---|---|---|
| `pkg/lifecycle.zsh` | `_hrd`, `hrd`, `hrdk` | ~73 |
| `pkg/project.zsh` | `hrd::start`, `hrd::project` | ~56 |
| `pkg/config-editor.zsh` | `edit-herdr-config`, `edit-herdr-plugins` | ~39 |
| `pkg/plugin.zsh` | `hrd::plugin` | ~63 |
| `pkg/worktree.zsh` | `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove` | **159 — OVER the 150 cap** |

`pkg/base.zsh` is NOT part of the split; it stays in place, renamed per D3.

**Fixing the over-cap file.** The git-flow prefix chain is already duplicated at `pkg/helper.zsh:266-273` and `:331-338`. Extract it into `hrd::internal::worktree::ensure_branch_prefix` in `internal/worktree.zsh`. Arithmetic: 159 − 14 (two 7-line copies removed) + 2 (call site) = 147 lines, under the cap.

RECOMMENDED (not mandated by the requirements): also extract the triplicated `{project_context}/{branch_leaf}` label construction into `hrd::internal::worktree::derive_label`, landing `pkg/worktree.zsh` near 136 lines. This makes label parity between create/open/remove a structural guarantee rather than a discipline three call sites must maintain by hand.

Both extracted helpers MUST go in `internal/worktree.zsh`, not `pkg/worktree.zsh` — defining them there would push that file back over the cap.

**Required `pkg/main.zsh` source order:**

1. `base.zsh` (existing, renamed per D3)
2. Platform stubs (`osx.zsh`, `linux.zsh`)
3. `lifecycle.zsh`
4. `project.zsh`
5. `config-editor.zsh`
6. `plugin.zsh`
7. `worktree.zsh`
8. `alias.zsh` LAST

**Real invariants (what actually constrains order).** The split files contain only function definitions — zero load-time execution. All cross-references are runtime calls into `internal/`, which is already fully loaded by the time `pkg/main.zsh` runs. So the hard constraints are: each file sourced exactly once, `base.zsh` first, `alias.zsh` last, and the order mirroring the original section order to keep the diff reviewable. Each new file keeps the shellcheck header (`# shellcheck shell=bash`).

**Scope interpretation of the 150-line cap** (stated now so it is not discovered mid-review): `internal/worktree.zsh` (163 lines) and `internal/install.zsh` (188 lines) ALREADY exceed 150 before this change. The cap in requirements #21–24 applies to the five split outputs of `pkg/helper.zsh`, not module-wide. Module-wide enforcement is separate Phase 4 work.

**Note:** `pkg/plugin.zsh` collides textually with the module-root `plugin.zsh` in grep output. Expected; the requirement names it.

### D5 — Fate of `bin/`: KEEP all three scripts as thin delegators to the zsh implementation.

Each of `bin/hrdw-create`, `bin/hrdw-delete`, `bin/hrdw-list` becomes a ~6-line bash shim that sources the checkout's own `zsh/zshrc` and execs the corresponding zsh function (`hrdw-create` → `hrdw::create`, `hrdw-delete` → `hrdw::remove`, `hrdw-list` → `hrdw::list`).

**THE DECIDING FACT: there is a live external caller.** `zsh/modules/github/data/gh-dash/config.yaml:89` runs `hrdw-create "{{.PrNumber}}"` on a PR-review keybinding, and `herdr/plugin.zsh` prepends `bin/` to PATH. Deleting the scripts breaks a real binding.

`herdr-cli` is an ACTIVE spec requiring all three CLIs with specific scenarios (usage on no-args, non-git error, exists-prompt, fzf+confirm removal). Delegation satisfies it as written without editing a single scenario.

Delegation structurally enforces the duplication requirements: one implementation, one derivation including slug/`core`/parent prefix (D1), one prefix helper (D4), one label format — by construction rather than by review. It also fixes a broken path for free: `bin/hrdw-delete <workspace-id>` today greps git output and can never match a workspace id; delegating to `hrdw::remove` makes the documented scenario work.

**Preserve or improve `-h/--help`.** It currently works in the bash scripts; delegation must not silently drop a working flag. The parity suite (Risk 2, guard d) asserts this.

**Alternatives rejected:**

| Alternative | Why rejected |
|---|---|
| Delete `bin/` entirely | Breaks the gh-dash keybinding and guts four `herdr-cli` requirements. |
| Keep only `hrdw-list` | Inverted priority: `hrdw-list` has no external caller, `hrdw-create` does. |

### D6 — `ZSH_HERDR_WORKSPACE_PREFIX`: DELETE it — both the declaration and the backward-compat re-export.

- Nothing reads it anywhere in the repo (verified: only `config/base.zsh:11` declaration and `:34` re-export exist).
- Requirement #14 (RD-234.md:67) forbids leaving a declared hook that no code reads; "keep as reserved" is explicitly not acceptable.
- Leaving a dead `*_WORKSPACE_PREFIX` next to the new live `ZSH_HERDR_PARENT_PREFIX_MAP` invites users to set it and silently get nothing.
- The `config/base.zsh:34` re-export (`HERDR_WORKSPACE_PREFIX="${ZSH_HERDR_WORKSPACE_PREFIX}"`) must go too — with `:11` removed it would export an empty string forever, i.e. a new dead symbol. The other four backward-compatible re-exports (`HERDR_PACKAGE_NAME`, `HERDR_INSTALL_URL`, `ZSH_HRD_PROJECT_TEMPLATE_PATH`, `ZSH_HRD_PLUGIN_ENABLED`) mirror live variables and stay.
- No code migrates. A user who set it in `~/.customrc` keeps an ignored variable; zsh does not error on unknown exports. Note it in the PR/changelog and update the stale `herdr-project.md` row during Phase 4 doc reconciliation.
- If a prefix feature is ever needed, `ZSH_HERDR_PARENT_PREFIX_MAP` (D1) is the extension point.

## Risks / Trade-offs

1. **Phase 3 is not zero-observable-change.** The `bin/` unification is the only Phase-3 step that changes behavior, and it hides inside a phase that claims zero change. It moves where worktrees land on disk, adds workspace-create/focus/layout side effects to a command that had none, and narrows `hrdw-list` from all git worktrees to herdr-managed ones. → Amend the Phase 3 claim explicitly to carve out `bin/` as the sanctioned exception; document the three deltas in the PR and regenerate the README.

2. **Highest-risk step is the `bin/` unification, not the split.** It introduces zsh re-entry from bash — a mechanism with no precedent in this repo — and it has a live external consumer (the gh-dash keybinding) that Phase 1 does not test. Its failure modes (lost args, drifted exit codes, output noise, wrong path math) are invisible to `zsh -n`, to shellcheck (`bin/` is excluded at `.pre-commit-config.yaml:147`), and to the rename cross-check. → Mitigation is a bats parity suite with a stub `herdr` on PATH that RECORDS ITS ARGV: (a) argv parity — running `hrdw-create RD-21` and `hrdw::create RD-21` in the same repo must produce identical recorded `herdr worktree create` invocations including `--branch feature/RD-21`, identical `--label`, `--cwd`, `--focus`; (b) exit-code parity for non-git dir, no-args usage, and declining the exists-prompt; (c) PATH contract — `command -v hrdw-create` resolves, and the exact gh-dash command string still resolves; (d) `--help` preservation.

3. **Second mandatory gate: the namespace rename.** ~85 sites, one dynamic string template (`internal/install.zsh:181`) that naive greps miss, failures deferred to interactive paths Phase 1 does not cover. → (a) call/definition cross-reference per `function-name-validation/spec.md:7-10`, scanning string literals; (b) load smoke asserting all 11 frozen names resolve via `whence -w`; (c) `zsh -n` over every module file; (d) bats suite green. Also: the two `deps::install::espresso` definitions must move in lockstep with the string template or espresso auto-install fails silently behind its enabled-flag guard.

4. **Legacy-label fallback can half-land.** Today the label is compared in TWO places — a `grep -qFx` existence check and a `jq` select in workspace-id resolution. If the fallback lands in only one, the launcher can report "exists" while resolution misses and falls through to CREATE, producing a duplicate despite the fallback. → Implement ONE choke-point resolver (try new label, else legacy, else new) consumed by both call sites. Add bats cases for new-exists / new-missing-legacy-exists / both-missing across both paths.

5. **Quantified blast radius of the label change.** Only third-branch labels whose parent has a map entry change. For HOME branches and unmapped parents the new label EQUALS the legacy label, so the fallback never runs and risk is exactly zero. Worktree labels change for the same parents, but open/remove resolve by BRANCH not label, so that path is structurally safe. The residual risk is hand-renamed workspaces ∩ mapped parents ∩ name-based invocation — a rare triple, since the module has no rename command. Worst outcome is an additive duplicate workspace plus an explicit error; data-loss risk is effectively zero. → Mitigate with the choke point plus a warning before creating on a double miss.

6. **The test runner must never pass vacuously.** `bats` is absent from CI, pre-commit, every Taskfile, and nix/provision. The precedent runner is broken: without `nullglob` the empty-glob guard in `zsh/modules/git/tests/run.sh` never fires. → Four anti-vacuous guards in order: (1) `nullglob` + zero `.bats` files → exit 1; (2) `bats` not installed → exit 1 with install hints, never skip; (3) zero `@test` blocks found → exit 1; (4) propagate bats exit code with no `|| true`. Follow the precedent's LAYOUT, not its code. Wire `task test` for devs and a direct `bash run.sh` step in CI (the workflow never installs `task`, and a direct invocation also sidesteps pre-commit's global exclude regexes). Do NOT add a bats pre-commit hook — it would hard-fail dev machines lacking bats. Residual vacuous-pass vectors to keep out of the runner: `continue-on-error`, `|| true`, `ignore_error: true`, or deleting the zero-file guard.

7. **`zsh -n` belongs in pre-commit; bats does not.** zsh is guaranteed present on every dev machine and in CI, so the syntax check can hard-fail both gates. bats is not installed anywhere by default (see Risk 6), so it is wired to `task test` and a direct CI step only. Pre-commit gets `zsh -n` plus existing shellcheck; it does not get bats.

## Migration Plan

Phase ordering is non-negotiable. Each phase must leave the module's tests green before the next begins. No user migration is required at any point: behavior converges rather than breaking.

| Phase | Content | Observable change | Gate before next phase |
|---|---|---|---|
| 1 — Test net | `zsh/modules/herdr/tests/` bats runner with anti-vacuous guards, `task test` target, naming-branch and slug cases, `hrd::project` exit codes against mocked `herdr`. Touches no production code. | None | Suite green; runner exits 1 on empty dir / missing bats / zero `@test` blocks (verified by deliberately empty runs). |
| 2 — Naming | `core::workspace::derive_name` (D1), `ZSH_HERDR_PARENT_PREFIX_MAP` in `config/base.zsh`, single choke-point legacy fallback, tmux delegates with empty map. | New labels for mapped parents only; legacy fallback covers pre-existing workspaces; tmux unchanged. | Suite green including new-exists / legacy-exists / both-missing cases on both resolution paths; tmux session-name parity cases green. |
| 3 — Restructure | `pkg/helper.zsh` split (D4), `bin/` delegation (D5), namespace rename (D3), prefix-chain and label construction extracted to `internal/worktree.zsh` (D4). | **Sanctioned exception:** `bin/` unification only (see below). Everything else zero-change. | Suite green including the bin parity suite (Risk 2 a–d); `whence -w` load smoke for all 11 frozen names; `zsh -n` over every module file; `grep -r 'herdr::' zsh/modules/herdr` empty. |
| 4 — Hygiene | `herdr-project.md` reconciliation (2-tab layout, derivation rules, dead-variable row), dead code removal (`derive_repo_name`, `list_templates`, `select_template`, empty stubs per the internal-module-structure delta), `ZSH_HERDR_WORKSPACE_PREFIX` confirmed gone (D6 — landed in Phase 2/3 with the config change, documented here), indentation normalized to `.editorconfig`, `zsh -n` in pre-commit and CI. | None (docs + dead code). | shellcheck passes module-wide; `zsh -n` in both gates; README regenerated. |

**The three observable `bin/` deltas** (Phase 3 carve-out, documented in the PR):

1. `hrdw-create` moves where worktrees land on disk (herdr-managed location vs raw `git worktree` path) and gains workspace-create/focus/layout side effects it never had.
2. `hrdw-list` narrows from all git worktrees to herdr-managed workspaces.
3. `hrdw-delete <workspace-id>` starts working as documented (today it can never match a workspace id in git output).

**README.md is GENERATED.** Regenerate via `task readme` from `README.yaml` after any change to files or commands. Never hand-edit `README.md`.

**Dead-variable removal** (`ZSH_HERDR_WORKSPACE_PREFIX` declaration + `HERDR_WORKSPACE_PREFIX` re-export, D6): noted in the PR/changelog; the stale `herdr-project.md` row is updated in Phase 4.

**Rollback.** Revert the commit set in reverse phase order. One caveat: reverting Phase 2 after users have created new-format labels re-exposes those workspaces to the double-miss scenario (Risk 4) — new-format labels stop being tried, so the resolver misses them and may recreate duplicates. If a Phase-2 revert is ever needed, either keep the choke-point resolver or clean up new-format workspaces first.

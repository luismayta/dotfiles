# Tasks

## 1. Decision record (ADR)

- [x] 1.1 Draft the transversal ADR under `.codi/jira/PE-699/adr/` containing the C1–C6 definitions as authored for PE-699 (design.md decision 1), the criterion precedence rules (decision 2), and the full 40-module ARCHIVE/DISABLE/KEEP matrix with one-line rationales from design.md decision 7 — verify with `codi okf validate <adr-file>` and by confirming all 40 module directories in `zsh/modules/` appear exactly once in the matrix
- [x] 1.2 Promote the ADR into `docs/adr/` at the repo root (AGENTS.md transversal-decision placement), recompute the OKF id, and verify `codi okf validate` passes on the promoted path and the ADR states that criteria C1–C6 were authored for this proposal because the source requirements referenced but did not define them

## 2. Default disable: devbox

- [x] 2.1 Flip `zsh/modules/devbox/config/base.zsh` to `ZSH_DEVBOX_ENABLED="${ZSH_DEVBOX_ENABLED:-false}"` and move the `__ZSH_DEVBOX_LOADED` guard assignment in `zsh/modules/devbox/plugin.zsh` below the `$ZSH_DEVBOX_ENABLED || return` check — verify in a fresh `zsh -f` session that sources core then `zsh/modules/devbox/plugin.zsh` with defaults: `__ZSH_DEVBOX_LOADED` is unset and `devbox::internal::main`-defined public functions are undefined
- [x] 2.2 Add `zsh/modules/devbox/tests/lifecycle.bats` modeled on `zsh/modules/notify/tests/hooks.bats` with three cases: anti-vacuous control (opted in → guard set, public functions defined), default-disabled (guard unset, functions undefined), and reversal (`export ZSH_DEVBOX_ENABLED=true` before startup → defined) — verify `bats zsh/modules/devbox/tests/lifecycle.bats` passes all cases
- [x] 2.3 Document the devbox disable and its reversal (`export ZSH_DEVBOX_ENABLED=true` in `$CUSTOMRC`, or `ZSH_DISABLED_MODULES="devbox"`) in `docs/env-vars.md`, `.customrc.example`, and `zsh/modules/README.md` — verify the documented commands restore the module in a fresh shell when run as written

## 3. Single activation: mise and atuin

- [x] 3.1 Remove the unconditional atuin activation at `zsh/zshrc:116` and the duplicate mise activation block at `zsh/zshrc:120-121`, keeping surrounding comments accurate — verify `grep -rn "mise activate" zsh/` matches exactly one line (`zsh/modules/devops/internal/mise.zsh`) and `grep -rn "atuin init" zsh/` matches only `zsh/modules/devops/internal/atuin.zsh` (acceptance test 5)
- [x] 3.2 Verify `git diff zsh/zshrc` shows only those deletions: the two `ZSH_DISABLED_MODULES` checks (`:35`, `:60`), the `$CUSTOMRC` bootstrap (`:43-49`), the system loop, module loop, and PATH dedupe are untouched, and no new exclusion branch or blacklist exists (acceptance tests 2, 12 precondition)
- [x] 3.3 In a directory containing `mise.toml`, start a fresh shell and verify `node`, `go`, `python`, `rust` resolve to mise/nix-provided binaries (`command -v` points at mise shims or nix store) and that `echo $PATH | tr ':' '\n' | uniq -d` and the same for `FPATH` are empty (acceptance test 6); also confirm `DEVOPS_MISE_INIT_FLAGS` still reaches the retained activation by setting it to `("--shims")` in `$CUSTOMRC` and observing the flag in `mise activate` output (devops-mise delta scenario)

## 4. Documentation updates

- [x] 4.1 Update `zsh/modules/README.md` (disable mechanism, `ZSH_<MODULE>_ENABLED` lifecycle policy section, and fix the stale intro: `zsh-brew`/`zsh-rust` examples and `mod/main.zsh` claim) plus `.customrc.example` examples — verify the rendered snippets run as written in a fresh shell
- [x] 4.2 Update `docs/env-vars.md` with `ZSH_DISABLED_MODULES`, `ZSH_DEVBOX_ENABLED`, and the ordering limitation that `$CUSTOMRC` is sourced after the `zsh/system/*` loop (`zsh/zshrc:43-49` vs `:27-40`) and before the `zsh/modules/*` loop (`:56-66`) — verify the documented line numbers against the current `zsh/zshrc`
- [x] 4.3 Update the generated root README by editing `provision/generators/README.yaml` only and running `task readme` — verify `README.md` changed via regeneration (`git diff README.md` shows generator output) and that `README.md` was never edited by hand
- [x] 4.4 Record in the docs that genuine dependency failures still emit `message_warning`/`message_error` despite disabled modules (acceptance test 11) — verify by tracing one failing path (e.g. missing dependency in an enabled module) still prints its warning in a fresh shell, and that `git diff` removes no diagnostic call

## 5. Integration and acceptance verification

- [x] 5.1 Run `openspec validate review-zsh-modules-lifecycle` and verify it reports no validation errors for the change (including both spec deltas)
- [x] 5.2 Smoke-test shared helpers in a fresh shell (acceptance test 4): verify `(( $+functions[git::internal::get_module_path] && $+functions[devops::direnv::install] && $+functions[goenv::internal::package::install] && $+functions[hrd::internal::osx::ensure_clipboard] ))` — the acceptance names `git::get_module_path` and `osx::ensure_clipboard` map to these two actual definitions
- [x] 5.3 Verify the ARCHIVE gate for `rvm` (acceptance test 3 semantics): strict namespace-prefix search `grep -rn --include='*.zsh' -E '(^|[^a-zA-Z0-9_])rvm::' zsh/modules zsh/system | grep -v '^zsh/modules/rvm/'` returns zero matches, using the strict-prefix interpretation documented in design.md (literal substring `grep -r "rvm::"` also expected clean, but the strict form is authoritative for modules with known substring collisions)
- [x] 5.4 Verify platform/host placement (acceptance test 10): exactly six platform disables remain in `config/osx.zsh`/`config/linux.zsh` (alacritty, hyprland, mpd, waybar, hammerspoon, osx) over `:-true` base defaults, devbox's flip is a global default (not platform-scoped), and no host-scoped disable was added to any repository file (host scope lives only in `$CUSTOMRC` docs/examples)
- [x] 5.5 Verify per-host reversibility in a fresh shell (acceptance test 9): with `$CUSTOMRC` containing `export ZSH_DEVBOX_ENABLED=true`, devbox loads (guard set, functions defined); with `ZSH_DISABLED_MODULES="devbox"` instead, it stays skipped by the existing loop — both without any code change
- [ ] 5.6 Measure startup with `ZSH_DEBUG=1` (`zprof`) before and after this change on a Linux host and a macOS host; attach top-10 entries to the issue and verify no regression greater than 10% (acceptance test 7)
- [x] 5.7 Run `task readme` a second time and the devbox bats suite plus `zsh/modules/notify/tests/hooks.bats` (loader-regression guard) — verify all pass and that re-running the generator produced no further diff (idempotent)

## Workflow follow-up

- Delivery B: create a DEDICATED follow-up change `archive-redundant-zsh-modules` (spec-driven: proposal, specs, design, tasks) separate from this change's DISABLE work; it deletes `zsh/modules/rvm/` only after re-running task 5.3's strict-prefix check for `rvm`, references the git history for the removal (`git log --follow -- zsh/modules/rvm/`), updates module-count mentions in docs, and pushes only manually — never automatically (acceptance test 13).
- After `openspec/changes/make-fnm-yield-to-mise` archives, re-run the lifecycle review for `nodejs`/fnm (C1/C2 verdict deferred per design.md decision 7, row 23).
- Propose a separate change to migrate the devops → `goenv::internal::package::install` call sites (`zsh/modules/devops/internal/base.zsh:71`, `internal/kubectl.zsh:58,62`, `pkg/kubectl.zsh:26`) before reclassifying `goenv` from KEEP (C3 gate, design.md decision 7, row 14).
- Archive this change and verify the archived result once the project's review requirements are satisfied.

## Verification notes

- Task 3.3 (accepted interpretation): `node`, `go`, `python` resolve to mise/nix-provided binaries; `PATH`/`FPATH` duplicate check empty; `DEVOPS_MISE_INIT_FLAGS` reaches retained activation. `rust` resolves to rustup at `~/.cargo/bin` (pre-existing host state, not a regression) — accepted as the rustup interpretation; this host has no `rust` command installed via mise/nix.
- Task 5.2 (accepted platform-conditional reading): on Linux `herdr/internal/main.zsh` defines `hrd::internal::linux::ensure_clipboard`; on macOS it defines `hrd::internal::osx::ensure_clipboard`. The acceptance expression passes under simulated `OSTYPE=darwin`. Spec left unchanged per user decision.
- Task 5.6 (deferred): Linux measurements recorded in `.codi/jira/PE-699/reports/2026-11-26-startup-zprof.md` (wall-clock median 0.808s → 0.633s; zprof total self 904ms → 772ms = −14.6%; no >10% regression). macOS follow-up still open; run `ZSH_DEBUG=1 zsh -i -c exit` (best-of-4 zprof) on a macOS host. Task left unchecked until macOS data exists.
- Ratification: the conditional `DEVOPS_MISE_INIT_FLAGS` guard in `zsh/modules/devops/config/mise.zsh` (so `$CUSTOMRC` values are not reset) is ratified and retained.

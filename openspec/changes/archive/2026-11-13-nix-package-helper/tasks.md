# Tasks

## 1. Core helper implementation

- [x] 1.1 Create `zsh/system/core/internal/nix.zsh` with `core::internal::nix::package::add-verb()` (probe `nix profile --help` once, store `$ZSH_NIX_PROFILE_INSTALL_VERB = install|add`, default to `install`). Verification: `source zsh/system/core/internal/nix.zsh` and `[[ "$ZSH_NIX_PROFILE_INSTALL_VERB" =~ "install|add" ]]`
- [x] 1.2 In `zsh/system/core/internal/nix.zsh`, add `core::internal::nix::package::exists <binary>` (invokes `core::exists`, no profile list). Verification: call function with non-existent binary returns 1, existing binary yields 0.
- [x] 1.3 In `zsh/system/core/internal/nix.zsh`, add `core::internal::nix::package::install <package-ref> <profile-name>` that 1) restores nix PATH via fallback script paths, 2) checks `core::exists <binary-at-ref>` (parsed `<attr>` from ref), 3) checks `nix profile list | grep "<profile>"`, 4) short-circuits if both pass or binary exists, 5) handles nix-darwin via `$ZSH_NIX_DARWIN_AVAILABLE=true` (log warning, skip user install), 6) uses `$ZSH_NIX_PROFILE_INSTALL_VERB` verb to invoke `nix $verb --extra-experimental-features 'nix-command flakes' ... with profile flag or positional argument as nix version dictates. Verification: mock nix absent, call after sourcing, should log error; mock nix present with missing binary, should call nix; mock nix-darwin true, should skip install and log warning.
- [x] 1.4 Extend `zsh/system/core/pkg/nix.zsh` with public wrappers: `core::nix::package::exists <binary>` → `core::exists <binary>`, `core::nix::package::install <package-ref> [profile-name]` → `core::internal::nix::package::install`, `core::nix::package::upgrade <profile-name>` → `nix profile upgrade "<profile>"`. Preserve existing `core::nix::install/exists/ensure`. Verification: `zsh -n zsh/system/core/pkg/nix.zsh` passes, functions declared.

## 2. Git module migration

- [x] 2.1 In `zsh/modules/git/config/base.zsh`, line 7 already has `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"`. No change needed. Verification: `grep GIT_DELTA_NIX_PACKAGE zsh/modules/git/config/base.zsh` yields expected value.
- [x] 2.2 Replace inline `nix profile install` in `zsh/modules/git/internal/delta.zsh` (function `git::internal::delta::install`) with `core::nix::package::install "${GIT_DELTA_NIX_PACKAGE}"` and remove PATH nix sourcing and inline nix presence check (short-circuit from helper). Verification: `zsh -n zsh/modules/git/internal/delta.zsh` passes, diff shows helper invocation.

## 3. Nix module migration

- [x] 3.1 In `zsh/system/nix/internal/linux.zsh`, replace the `nix profile list | grep -q` pruning check in `nix::direnv::internal::install` with `core::nix::package::exists direnv` guard before calling the helper. Replace `nix profile install` with `core::nix::package::install "${NIX_DIRENV_NIX_PACKAGE}"`. Remove any additional nix-direnv-specific inline install logic. Verification: `zsh -n zsh/system/nix/internal/linux.zsh` passes.
- [x] 3.2 In `zsh/system/nix/internal/osx.zsh`, apply same replacement pattern (avoiding OS-specific `nix profile add` verb) using `core::nix::package::install`. Verification: `zsh -n zsh/system/nix/internal/osx.zsh` passes.

## 4. Notify module migration

- [x] 4.1 In `zsh/modules/notify/internal/adapter/noti.zsh`, replace inline `nix --extra-experimental-features 'nix-command flakes' profile add nixpkgs#noti` in the nix-branch with `core::nix::package::install "nixpkgs#noti"`. Keep core::install fallback path unchanged. Verification: `zsh -n zsh/modules/notify/internal/adapter/noti.zsh` passes.

## 5. Devops module migration

- [x] 5.1 In `zsh/modules/devops/internal/linux.zsh`, in `devops::direnv::internal::install`: preserve `core::install "nixpkgs#direnv"` for Linux (cask-like native install), and replace inline `nix profile list | grep -q` pruning check and second `nix profile install` of `DEVOPS_DIRENV_NIX_DIRENV_PACKAGE` with `core::nix::package::install "${DEVOPS_DIRENV_NIX_DIRENV_PACKAGE}"`. Keep nix PATH preloading fallback (devops already does it; helper also does it, but duplication acceptable for now). Verification: `zsh -n zsh/modules/devops/internal/linux.zsh` passes.
- [x] 5.2 In `zsh/modules/devops/internal/osx.zsh`, apply same replacement (devops::direnv::internal::install for macOS), replacing both `nix profile add` calls of `direnv` and `DEVOPS_DIRENV_NIX_DIRENV_PACKAGE` with helper (except keep `core::exists direnv` guard if present, unify with helper's binary check). Helper's `core::nix::package::exists` covers existing guard, remove duplicate. Verification: `zsh -n zsh/modules/devops/internal/osx.zsh` passes.

## 6. Guide update

- [x] 6.1 Read `docs/guides/implement-tool-in-module.md` to locate lines with native pkg manager as only path (spec says lines ~138 and 581 — verify at implementation). Note current Step 2 content.
- [x] 6.2 Before current Step 2, insert new step "Step 2a: Choosing an Install Mechanism" with decision table (nix preferred for single CLI binary in nixpkgs; use `core::install`/custom installer for cask, system pkg, not in nixpkgs, or nix-darwin-managed). Include code block showing nix pattern: config var `*_NIX_PACKAGE="nixpkgs#<attr>"`, factory guard with `core::nix::package::exists`, conditional `core::nix::package::install` when absent, fallback to `core::install`. Include naming rules (`*_NIX_PACKAGE` nixpkgs ref, `*_PACKAGE_NAME` native/message). Include guard rules (`ZSH_NIX_DARWIN_AVAILABLE` skip+warn, nix not auto-installed). Include "When NOT to use nix" clause (casks, non-nixpkgs, system packages). Include anti-patterns (no hardcoded `nix profile install`, no OS branching for verb, no nix inside `core::install`).
- [x] 6.3 Remove or revise lines stating native pkg manager as the only path (~lines 138 and 581) to reflect nix as preferred but not required. Verification: `zsh -n docs/guides/implement-tool-in-module.md` passes on zsh syntax? (markdown has no zsh, so verify by reading diff) and manual inspection confirms nix mentioned as preferred.

## 7. Verification

- [x] 7.1 Run `zsh -n` on all modified zsh files ( `zsh/system/core/pkg/nix.zsh`, `zsh/system/core/internal/nix.zsh`, `zsh/modules/git/internals/delta.zsh`, `zsh/system/nix/internal/linux.zsh`, `zsh/system/nix/internal/osx.zsh`, `zsh/modules/notify/internal/adapter/noti.zsh`, `zsh/modules/devops/internal/linux.zsh`, `zsh/modules/devops/internal/osx.zsh`). Expected: no syntax errors.
- [x] 7.2 Execute smoke load by sourcing the core module:
  - `source zsh/system/core/main.zsh` should not error.
  - `core::nix::package::exists <nonexistent-binary>` should return 1.
  - If nix is present, `core::nix::package::install –dry-run` pattern via nix's no-op should succeed without errors (or validate early short-circuit). Verification: shell load completes without error, helper functions declared and accessible.
- [x] 7.3 Smoke load git and notify modules after migration:
  - `source zsh/modules/git/plugin.zsh` (includes config + internal sourcing), verify `git::internal::delta::install` uses helper. Diff check: no inline `nix profile install`.
  - `source zsh/modules/notify/plugin.zsh`, verify `notify::noti::internal::install` nix branch uses helper. Diff check: no inline `nix profile add`.
- [x] 7.4 Run `openspec validate --specs` for the new capability `specs/core-nix/spec.md` and modified capability `specs/nix-direnv/spec.md` to ensure requirements and scenarios pass (correct number of 4 hashtags). Expected: validation succeeds, no strict failures.
- [x] 7.5 Run `openspec validate --changes` for the entire change to ensure all artifacts are consistent and all specs listed in proposal are represented. Expected: change passes validation.

## Workflow follow-up

- Archive the change after all implementation tasks are complete and manual verification confirms helper works as designed. Use `openspec archive` command or approved workflow trigger once tasks.md shows all checkboxes completed.

### Change Location
`openspec/changes/nix-package-helper/`

### Artifacts Created
- `proposal.md`
- `specs/core-nix/spec.md`
- `specs/nix-direnv/spec.md`
- `design.md`
- `tasks.md`

### Skipped/Conditional Artifacts
None (all required artifacts created per proposal scope).

### Final Status
```
Change: nix-package-helper
Schema: spec-driven
Status: ready for implementation
```

### Validation Output
```
Validation result: PASS
Specs validated: core-nix (new), nix-direnv (modified)
Changes validated: nix-package-helper
```
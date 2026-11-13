## 1. Task A — git module: delta as nix dependency (KentBeck)

- [x] 1.1 In `zsh/modules/git/config/base.zsh`, declare `export GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"`.
- [x] 1.2 Create `zsh/modules/git/internal/delta.zsh` with `git::internal::delta::install` (guard with `core::exists delta`; source nix profile if needed; `nix profile install "${GIT_DELTA_NIX_PACKAGE}"`) and `git::internal::delta::load` (guard with `core::exists delta`; set `core.pager`, `interactive.diffFilter`, `delta.navigate`, `merge.conflictStyle`).
- [x] 1.3 In `zsh/modules/git/internal/main.zsh`, source `internal/delta.zsh` and invoke `git::internal::delta::install` and `git::internal::delta::load` alongside the existing `core::ensure` calls.
- [x] 1.4 In `zsh/modules/git/data/sync/.gitconfig`, change line `pager = hunk pager` to `pager = delta`, keeping `hunk pager` as a commented alternative.
- [x] 1.5 In `zsh/modules/git/README.yaml`, add delta to the `requirements` list.

## 2. Task B — rust module: remove duplicated delta ownership (LinusTorvalds, parallel to A)

- [x] 2.1 In `zsh/modules/rust/config/base.zsh`, remove `git-delta` from `RUST_CARGO_PACKAGES_SIMPLE`.
- [x] 2.2 In `zsh/modules/rust/internal/packages.zsh`, delete the `rust::internal::delta::load` function.
- [x] 2.3 In `zsh/modules/rust/plugin.zsh`, remove the orphan comment referencing delta.

## 3. Verification

- [x] 3.1 Run zsh syntax checks (`zsh -n`) on all modified/created zsh files.
- [x] 3.2 Smoke-test module load (source git and rust modules in a clean shell) without errors.

## 4. Follow-up (non-blocking, separate change)

- [x] 4.1 Sync `openspec/specs/rust-module/spec.md` (requirement "Delta git pager configuration") to remove the now-stale delta requirement, since ownership moved to the git module.

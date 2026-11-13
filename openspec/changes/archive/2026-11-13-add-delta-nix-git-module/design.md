# Design

## Context

The git module already owns git pager/config concerns and follows the 3-layer pattern (`config/` → `internal/` → `pkg/`), with `scmpuff` as the closest analog (install + load). The devops module provides a proven nix-based install pattern (`devops::direnv::internal::install` in `zsh/modules/devops/internal/linux.zsh`). The rust module's `rust::internal::delta::load` is defined but never invoked, and `git-delta` sits unused in `RUST_CARGO_PACKAGES_SIMPLE`. See proposal.md — Why.

## Goals / Non-Goals

**Goals:**
- Make the git module the sole owner of delta install + config, via nix.
- Mirror the existing scmpuff pattern (install + load) for consistency.
- Reuse the devops direnv nix install mechanism.

**Non-Goals:**
- Removing the rust-module spec requirement now (deferred follow-up).
- Changing hunk pager behavior beyond commenting it as an alternative.
- Adding delta to a cargo-based install path.

## Decisions

- **Nix as install mechanism**: Copy the devops direnv pattern (`core::exists` guard + `nix profile install "${GIT_DELTA_NIX_PACKAGE}"`) rather than cargo install. Rationale: delta ships as `nixpkgs#delta`; nix install is idempotent and matches the existing devops dependency model. Alternative considered: keep cargo install in rust module — rejected because it leaves ownership split and the cargo entry is unused.
- **New `git/internal/delta.zsh` file**: Mirrors `scmpuff::internal::install`/`load` (message_info → core::install → message_success; load guarded by `core::exists`). Rationale: matches existing git module conventions and keeps delta logic isolated and sourceable.
- **Wiring in `internal/main.zsh`**: Source the new file and invoke install/load alongside the existing `core::ensure git/hub/rsync/scmpuff` block, consistent with scmpuff invocation. Rationale: single entry point for module load.
- **Config var in `config/base.zsh`**: `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"`, placed next to other git config vars, following `DEVOPS_DIRENV_NIX_DIRENV_PACKAGE`.
- **`.gitconfig` pager change**: `pager = hunk pager` → `pager = delta`, with `hunk pager` kept as a commented alternative, consistent with the related change's Decision 5. Overlap with lines 156-159 (already set `diffFilter`, `[delta] navigate`, `merge.conflictStyle = zdiff3`) is intentional and non-conflicting: those are the same values `delta::load` applies at runtime; the synced file remains the source of truth for the pager line, and the runtime load keeps them consistent. No duplicate edits beyond the pager line.
- **Deferred rust-module spec sync**: `openspec/specs/rust-module/spec.md` "Delta git pager configuration" requirement becomes stale; tracked as a non-blocking follow-up task rather than performed here, per the change scope.

## Risks / Trade-offs

- **Overlap in `.gitconfig`** (pager line vs. lines 156-159) → Mitigation: only the pager line changes; the existing delta/merge/interactive blocks already match the migrated values, so no inconsistency is introduced.
- **Nix availability** → Mitigation: reuse the devops pattern's nix PATH sourcing fallback before invoking `nix profile install`; if nix is absent, fail with a clear message rather than silently.
- **Dead-code removal in rust** → Mitigation: `rust::internal::delta::load` is never invoked anywhere, so removal has no runtime impact; verified by search before deletion.

## Migration Plan

1. Add git-module delta support (config var, new file, wiring, gitconfig, README).
2. Remove rust-module delta ownership (cargo entry, dead function, orphan comment).
3. Run zsh syntax checks and module load smoke test.
4. (Follow-up, separate change) Sync `openspec/specs/rust-module/spec.md` to drop the "Delta git pager configuration" requirement.

## Open Questions

None.

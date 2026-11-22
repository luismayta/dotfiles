# Design

## Context

The devops module (`zsh/modules/devops/`) follows a documented three-layer tool architecture — `config/` (env vars), `internal/` (private implementation), `pkg/` (public API) — described in `docs/guides/implement-tool-in-module.md`. Two integration patterns exist: **Shell hooks** (atuin, direnv: `eval "$(tool ...)"` inside `internal/`) and **PATH-only** (caddy, bruno). Installation helpers live in `zsh/system/core/pkg/nix.zsh` (`core::nix::package::exists|install|upgrade`) and `core::install` / `core::ensure` for the native path. See proposal.md for motivation; `specs/devops-mise/spec.md` for the behavior contract.

## Goals / Non-Goals

**Goals:**

- Add `mise` as a standard devops tool with zero deviation from the established atuin/caddy conventions.
- Prefer nix for installation (`nixpkgs#mise`) with a native fallback, never requiring nix.
- Activate mise's zsh integration on shell load with user-configurable flags.
- Expose the standard `install` / `upgrade` / `post_install` public API.

**Non-Goals:**

- Managing mise configuration files (`mise.toml`, `.tool-versions`) or syncing them from `data/`.
- Installing language runtimes or tools through mise on behalf of the user.
- Completions, aliases, or tasks configuration beyond the activation hook.
- Changes to other modules or to the core install helpers.

## Decisions

**Shell hooks pattern (atuin-style) over PATH-only.**
mise ships `mise activate zsh`, which installs chpwd hooks for per-project version switching — the tool's core value. PATH-only would leave it inert. Alternative considered: PATH-only with manual `mise exec`, rejected because it loses automatic project activation.

**nix-first install with `core::install` fallback (guide Step 2a).**
`mise` is a single static binary present in nixpkgs, matching the "Single CLI binary in nixpkgs" row. `DEVOPS_MISE_NIX_PACKAGE="nixpkgs#mise"` plus `DEVOPS_MISE_PACKAGE_NAME=mise` gives the helper the flake ref and the native package name. Alternative: `core::ensure mise` only — rejected because it gives up nix preference; custom installer (`curl | bash`) — rejected because it bypasses package management and the guide's anti-patterns.

**Guard order in `internal/`: `load` then `main::factory`, both called at source time.**
Matches `atuin.zsh` and `caddy.zsh` exactly, so the module stays uniform and reviewable. `load` early-returns unless `core::exists mise`, so a missing binary never produces a broken `eval`.

**Load-before-install trade-off.**
When the factory installs mise in the current session, the activation hook from `load` has already been skipped; activation takes effect on the next shell start. Accepted for consistency with atuin; re-running `load` after install was considered and rejected as a deviation that complicates the pattern without an acceptance-test benefit.

**Flags via an array variable.**
`DEVOPS_MISE_INIT_FLAGS=()` expanded unquoted inside `eval "$(mise activate zsh ${DEVOPS_MISE_INIT_FLAGS[@]})"`, mirroring `DEVOPS_ATUIN_INIT_FLAGS`, so users can add options (e.g. `--shims`) from their own config without editing module files.

**Configuration stays declarative.**
`config/mise.zsh` holds only `export` statements (no install logic, no `eval`), per the guide's layer rules and anti-patterns.

## Risks / Trade-offs

- [Factory auto-installs at every shell start when mise is missing, adding startup latency] → The install short-circuits on `core::exists mise`, so the cost is paid once; the nix path is also idempotent.
- [nix-darwin managed machines must not receive user-profile installs] → Follow the Step 2a guard: check `ZSH_NIX_DARWIN_AVAILABLE` and skip with a warning.
- [nix absent on a machine] → Fall back to `core::install "${DEVOPS_MISE_PACKAGE_NAME}"; nix is preferred, never required.
- [`mise activate` eval cost on shell startup] → Guarded by `core::exists mise`; flags are user-tunable via `DEVOPS_MISE_INIT_FLAGS`.
- [Forgetting one of the three `source` lines silently breaks the tool] → Explicit wiring task plus the functional verification scenario (`type devops::mise::install`).

## Migration Plan

Additive only. Rollback = remove the three `source` lines, the `mise` entry in `DEVOPS_TOOLS`, and the three new files; no data or config migration is involved.

## Open Questions

None. Behavior, install mechanism, and file layout are fixed by the acceptance tests in `.codi/jira/PE-661/requirements/PE-661.md`.

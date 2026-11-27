# Proposal

## Why

nix and mise are now the source of truth for toolchains and project versions, but all 40 modules under `zsh/modules/` are still glob-sourced on every shell start (`zsh/zshrc:56-66`) with no lifecycle policy — so redundant version managers and GUI integrations keep loading, hooks/PATH duplicate (e.g. `mise activate zsh` at `zsh/zshrc:121` and `zsh/modules/devops/internal/mise.zsh:10`), and nobody has classified each module as ARCHIVE, DISABLE, or KEEP. The requirements (PE-699) demand "C1–C6 criteria" in the decision matrix but define them nowhere in the repo; for this proposal the six criteria were authored and are AUTHORITATIVE (full definitions in `design.md`): **C1** nix/mise installation redundancy, **C2** duplicate shell integration, **C3** cross-boundary shared-helper usage, **C4** platform scope, **C5** interactive/user-facing value, **C6** startup cost & reversibility.

## What Changes

- Define a module lifecycle policy that classifies all 40 modules as ARCHIVE / DISABLE / KEEP, applying C1–C6 per module with a one-line rationale; captured in a transversal ADR (promoted to `docs/adr/` during implementation) and in a new spec capability.
- Flip default-disabled (**BREAKING** behavioral change on fresh shells, fully reversible via `ZSH_DISABLED_MODULES=""` or `export ZSH_<MODULE>_ENABLED=true` in `$CUSTOMRC`) for modules judged redundant with nix/mise — using ONLY the existing `ZSH_DISABLED_MODULES` / `ZSH_<MODULE>_ENABLED` mechanisms; **no** new exclusion branch or central blacklist in `zsh/zshrc`.
- Resolve the mise duplication: exactly one effective `mise activate zsh` across `zsh/zshrc` and `zsh/modules/devops/`, by removing the duplicate or explicitly guarding it (modifies the `devops-mise` spec, which currently mandates module-level activation). Apply the same C2 finding to the duplicated atuin activation (`zsh/zshrc:116` unconditional vs the devops module's guarded `atuin init`), which `devops-atuin` already assigns to the module.
- Keep shared helpers intact: `git::internal::get_module_path`, `devops::direnv::install`, `goenv::internal::package::install`, and `hrd::internal::osx::ensure_clipboard` must remain defined after a fresh shell start; any ARCHIVE candidate with references outside its directory is blocked until migrated (C3).
- Platform-scoped disables live only in `config/osx.zsh` / `config/linux.zsh` over a `:-true` base default; host-scoped disables live only in `$CUSTOMRC`.
- Preserve diagnostics: genuine dependency failures still emit `message_warning` / `message_error`; no output suppressed to hide a disabled module's missing helper.
- Update docs: generated root `README` (via `provision/generators/README.yaml` or `task readme` — never `README.md` directly), `zsh/modules/README.md`, `.customrc.example`, `docs/env-vars.md`, including that `$CUSTOMRC` is sourced after the `zsh/system/*` loop (`zsh/zshrc:43-49` vs `:27-40`) and before the module loop (`:56-66`).
- Add bats tests (modeled on `zsh/modules/notify/tests/hooks.bats`) for every changed default, asserting `__ZSH_<MODULE>_LOADED` unset / public functions undefined when disabled and defined when enabled.
- Split delivery (**ARCHIVE** removals are **excluded** from this change): this change delivers DISABLE/default changes + policy docs/spec; ARCHIVE file removals go to a dedicated follow-up change `archive-redundant-zsh-modules`, referencing git history, with no automatic push.

## Capabilities

### New Capabilities

- `zsh-module-lifecycle`: lifecycle classification of `zsh/modules/*` into ARCHIVE / DISABLE / KEEP under criteria C1–C6, default-disable behavior through existing enable/disable mechanisms only, reversibility via `$CUSTOMRC`, platform-scoped disable placement, preserved failure diagnostics, and lifecycle documentation.

### Modified Capabilities

- `devops-mise`: the "mise zsh shell activation" requirement currently mandates module-level `eval "$(mise activate zsh ...)"` during devops module load — it changes so exactly one effective activation remains across `zsh/zshrc:121` and the devops module (duplicate removed or explicitly guarded), keeping `DEVOPS_MISE_INIT_FLAGS` honored by whichever activation is retained.

## Impact

- Code (implementation phase): `zsh/modules/<changed>/config/base.zsh` defaults and platform config files, `zsh/modules/devops/internal/mise.zsh` (or `zsh/zshrc:120-121`) for the activation dedupe, new/updated bats tests under `zsh/modules/*/tests/`. `zsh/zshrc` loader logic itself is NOT modified.
- Shared-helper consumers at risk if ARCHIVE is misapplied: `zsh/system/core/internal/backup.zsh:35` (git), `zsh/system/nix/pkg/direnv.zsh:7-8` (devops), devops→goenv call sites, herdr clipboard helper — all verified in `design.md`'s cross-boundary matrix (C3).
- Docs: generated `README.md` (via generator source only), `zsh/modules/README.md`, `.customrc.example`, `docs/env-vars.md`, plus a new transversal ADR under `docs/adr/`.
- Interaction with in-flight change `openspec/changes/make-fnm-yield-to-mise/` (declares "Changing mise activation" a non-goal and defers fnm removal) — disabling `nodejs`/`devops` must be sequenced around it.
- Spec conflict resolved in this change's deltas: archived `2026-06-10-module-disable` scenario "skipped silently … without producing any diagnostic output" is superseded by the new lifecycle capability (diagnostics for genuine failures preserved); `zshrc-load` ordering requirements and the `make-fnm-yield-to-mise` constraints are respected.
- Delivery: two separate changes; ARCHIVE removals (`archive-redundant-zsh-modules`) reference git history and are never pushed automatically.

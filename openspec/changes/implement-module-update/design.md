## Context

Zsh modules follow a three-layer architecture (`config/`, `internal/`, `pkg/` plus `data/`) with a `plugin.zsh` entry point. The herdr module already implements `herdr::internal::install` in `zsh/modules/herdr/internal/install.zsh`, which runs `curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh`, then validates availability with `core::exists herdr` and returns `0`/`1` accordingly. Public functions live in `zsh/modules/herdr/pkg/base.zsh` (`herdr::install`, `herdr::plugin::update`, `herdr::plugin::update::all`). See proposal.md — Why for motivation.

## Goals / Non-Goals

**Goals:**
- Reuse the proven install pattern (installer + PATH validation + exit codes) for update.
- Additive, non-breaking: introduce `herdr::update` without touching existing functions.
- Provide a documented pattern other modules can copy.

**Non-Goals:**
- No version pinning or rollback management.
- No update of module configuration data (`data/`) — tool binary only.
- No automation beyond the explicit `update` function (no scheduled updates).

## Decisions

**D1 — Update = re-run the official installer (idempotent).**
`herdr::update` re-executes the same installer as install (`curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh`). Rationale: the official installer is the source of truth for the latest version and already handles binary placement. Alternative considered: downloading the release binary directly — rejected (duplicates installer logic and diverges from upstream behavior).

**D2 — New internal file `internal/update.zsh` hosting `herdr::internal::update`.**
Keeps lifecycle concerns separated (install vs update), matching the module's per-concern file convention. Alternative considered: appending to `internal/install.zsh` — rejected (file would mix install and update lifecycle logic).

**D3 — Public `herdr::update` in `pkg/base.zsh` delegates to `herdr::internal::update`.**
Follows the existing pattern (`herdr::install` → `herdr::internal::install`), keeping the public API thin and stable.

**D4 — Exit-code semantics mirror `install`.**
Return `0` when `core::exists herdr` passes after the installer; return `1` when the installer fails or the binary is absent from PATH.

## Risks / Trade-offs

- [Installer re-run may not cleanly upgrade if the tool changed layout] → Mitigation: rely on the official installer; it is the same mechanism `install` already uses, so behavior is consistent.
- [PATH may not contain the binary location after update] → Mitigation: the herdr module already prepends its bin path via `core::path::prepend`; `core::exists herdr` validates before returning success.
- [Additive function has no callers initially] → Mitigation: documented pattern + acceptance tests exercise it directly; low blast radius (no existing callers, confirmed via codegraph).

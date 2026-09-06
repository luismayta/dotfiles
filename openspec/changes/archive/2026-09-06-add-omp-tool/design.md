## Context

See proposal.md — Why. The AI module (`zsh/modules/ai/`) integrates AI coding agents (pi, opencode, jcode, fabric, ollama) using a strict three-layer architecture:

- `config/<tool>.zsh` — exports `ZSH_AI_<TOOL>_*` environment variables
- `internal/<tool>.zsh` — private functions `ai::internal::<tool>::*` (load, install, config::sync)
- `pkg/<tool>.zsh` — thin public facade `ai::<tool>::*` delegating to internal

Wiring happens in exactly three files: `config/base.zsh` (source + `ZSH_AI_TOOLS` array), `internal/main.zsh` (source + `::load` invocation), `pkg/main.zsh` (source). `plugin.zsh` chains the three layers and needs no changes. The reference implementation is `pi` (same agent family — omp is a fork of Pi by Mario Zechner), with `jcode-ai-tool` as the most recent spec precedent.

## Goals / Non-Goals

**Goals:**
- Mirror the pi integration exactly, adapted for omp (install URL, config paths, tool name)
- Zero changes to `plugin.zsh` or the core system
- Follow `docs/guides/implement-tool-in-module.md` (three-layer pattern, namespace `ZSH_AI_<TOOL>_` / `ai::<tool>::`)

**Non-Goals:**
- No new architectural patterns — reuse the existing three-layer convention
- No changes to other tools' behavior or the `ZSH_AI_TOOLS` iteration logic
- No omp-specific config content (settings/models) — the issue only requires the sync mechanism, not shipped config files

## Decisions

**D1: Clone pi as the template, not jcode.**
omp is a fork of Pi, so `config/pi.zsh`, `internal/pi.zsh`, `pkg/pi.zsh` are the closest structural match: same `curl | sh` install, same `~/.<tool>/agent` config convention, same `~/.local/bin` binary path. jcode differs (bash installer, `~/.config/jcode`, `::sync` naming). Rationale: minimal diff from a proven, same-family implementation.
*Alternative considered:* cloning jcode — rejected, different install/config conventions.

**D2: Variable naming `ZSH_AI_OMP_*`.**
Follows the actual code convention (`ZSH_AI_PI_*`, `ZSH_AI_JCODE_*`). Note: the archived `pi-agent` spec uses `AI_PI_*` but the live code uses `ZSH_AI_PI_*` — the code is authoritative.

**D3: Install via curl primary, bun documented.**
`curl -fsSL https://omp.sh/install | sh` matches the acceptance test and pi pattern. `bun install -g @oh-my-pi/pi-coding-agent` is the documented alternative (bun >= 1.3.14 required by omp; `bunx` is already guarded in plugin.zsh).

**D4: `ZSH_AI_OMP_BIN_PATH` = `~/.local/bin`.**
Consistent with pi. The curl installer for omp installs the binary there. If verification at implementation time shows a different path, adjust the variable value only — the spec requires the variable, not a hardcoded value.

**D5: `ZSH_AI_OMP_CONFIG_PATH` = `~/.omp/agent`, `ZSH_AI_OMP_CONFIG_SOURCE_PATH` = `$ZSH_AI_PATH/data/omp`.**
Mirrors pi (`~/.pi/agent` ← `data/pi`). Create `data/omp/` (empty, `.gitkeep`) so the sync source exists; the sync function warns if the source is missing (pi behavior).

**D6: Registration placement.**
- `config/base.zsh`: source `config/omp.zsh` adjacent to `config/pi.zsh`; append `omp` to `ZSH_AI_TOOLS`
- `internal/main.zsh`: source `internal/omp.zsh` adjacent to `internal/pi.zsh`; invoke `ai::internal::omp::load` in the "Load paths" block next to `ai::internal::pi::load`
- `pkg/main.zsh`: source `pkg/omp.zsh` adjacent to `pkg/pi.zsh`

**D7: Guard semantics.**
`ai::internal::omp::install` guards with `core::exists omp` (early return 0 if installed — pi pattern). `ai::internal::omp::load` checks binary existence before prepending to PATH. The acceptance test's "guard in load" is satisfied by the `core::exists` guard in the install flow plus the binary-existence check in load.

## Risks / Trade-offs

- [omp installer installs binary outside `~/.local/bin`] → Verify at implementation; adjust `ZSH_AI_OMP_BIN_PATH` value only (spec-compliant).
- [bun >= 1.3.14 missing] → curl installer is primary; `bunx` guard already exists in plugin.zsh; no new dependency wiring needed.
- [Empty `data/omp/` yields warning on sync] → Acceptable; matches pi behavior when source is absent; content can be added later without spec changes.
- [Acceptance test wording "guard in load" vs pi's guard-in-install] → Covered both: `core::exists` guard in install + binary check in load; spec states both scenarios.

## Migration Plan

Additive change — no migration. Rollback: delete `config/omp.zsh`, `internal/omp.zsh`, `pkg/omp.zsh`, `data/omp/` and revert the three wiring edits in `config/base.zsh`, `internal/main.zsh`, `pkg/main.zsh`.

## Open Questions

None — the issue is fully specified. The exact omp binary install path is verifiable at implementation time without changing specs, approach, or task breakdown.
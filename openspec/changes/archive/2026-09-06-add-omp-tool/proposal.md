## Why

RD-155: omp (Oh My Pi) is a coding agent with an integrated IDE, forked from Pi by Mario Zechner. The AI module (`zsh/modules/ai/`) already integrates similar agents (pi, opencode, jcode) using a three-layer architecture (config/internal/pkg). Adding omp gives users a new AI coding agent option with the same install/config-sync/PATH-loading experience as the existing tools.

## What Changes

- Add `config/omp.zsh` exporting `ZSH_AI_OMP_*` variables (BIN_PATH, CONFIG_PATH, CONFIG_SOURCE_PATH, INSTALL_URL)
- Add `internal/omp.zsh` with `ai::internal::omp::load`, `ai::internal::omp::install`, `ai::internal::omp::config::sync`
- Add `pkg/omp.zsh` with public functions `ai::omp::install`, `ai::omp::config::sync`
- Register omp in the module wiring: `config/base.zsh` (source + `ZSH_AI_TOOLS` array), `internal/main.zsh` (source + `::load` invocation), `pkg/main.zsh` (source)
- Follow the pi pattern: guard `core::exists omp`, curl-based install, rsync config sync
- No changes to `plugin.zsh` — it already chains the three layers

## Capabilities

### New Capabilities
- `omp-ai-tool`: Integration of omp as an AI module tool — configuration variables, PATH loading, curl-based installation, config synchronization, public API functions, and module registration following the three-layer architecture.

### Modified Capabilities
<!-- None — no existing spec-level behavior changes. -->

## Impact

- **Code**: `zsh/modules/ai/config/omp.zsh` (new), `zsh/modules/ai/internal/omp.zsh` (new), `zsh/modules/ai/pkg/omp.zsh` (new), `zsh/modules/ai/config/base.zsh` (edit), `zsh/modules/ai/internal/main.zsh` (edit), `zsh/modules/ai/pkg/main.zsh` (edit)
- **Data**: `zsh/modules/ai/data/omp/` (new — config source for sync, mirroring `data/pi/`)
- **Dependencies**: `bun >= 1.3.14` (omp requirement), `curl`, `rsync` (already guarded in plugin.zsh)
- **External**: https://omp.sh/install install script; config at `~/.omp/agent/`
- **Reference**: `docs/guides/implement-tool-in-module.md` (three-layer pattern), `pi` implementation as template
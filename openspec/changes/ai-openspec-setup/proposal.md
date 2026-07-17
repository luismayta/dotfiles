## Why

OpenSpec is already installed as an npm package and has skills/commands configured, but it lacks the same zsh module integration that graphify has. Users need shell functions to install, upgrade, and set up OpenSpec per-project — mirroring the `ai::graphify::*` pattern for consistency and discoverability.

## What Changes

- Add `AI_OPENSPEC_BIN_PATH` config variable following existing naming conventions
- Implement `ai::internal::openspec::{load,install,upgrade,setup,register_skill}` functions
- Add public wrappers `ai::openspec::{install,upgrade,setup}` in pkg/helper.zsh
- Register OpenSpec as a managed tool in the AI module's tool ecosystem

## Capabilities

### New Capabilities
- `openspec-shell-integration`: Zsh module functions for OpenSpec lifecycle management (install, upgrade, setup, PATH loading)

### Modified Capabilities
<!-- No existing capabilities are being modified -->

## Impact

- **Files Modified**:
  - `zsh/modules/ai/config/base.zsh` — new env var `AI_OPENSPEC_BIN_PATH`
  - `zsh/modules/ai/internal/base.zsh` — new internal functions
  - `zsh/modules/ai/pkg/helper.zsh` — new public wrapper functions
- **Dependencies**: `@fission-ai/openspec` npm package (already installed in nodejs module)
- **Breaking Changes**: None — purely additive

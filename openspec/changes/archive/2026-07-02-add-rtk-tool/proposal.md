## Why

The `rtk` CLI tool (from `rtk-ai/rtk`) provides AI-powered terminal assistance. Adding it to the AI module ensures consistent installation, PATH management, and discoverability alongside existing tools like opencode, fabric, ollama, and codegraph. This follows the established pattern of managing all AI tooling through a single, idempotent module.

## What Changes

- Add `rtk` installation URL to `zsh/modules/ai/config/base.zsh`
- Add `AI_INSTALL_URL_RTK` and include `rtk` in `$AI_TOOLS` array
- Add `ai::internal::rtk::install` function in `zsh/modules/ai/internal/base.zsh`
- Add `ai::internal::rtk::load` PATH loader in `zsh/modules/ai/internal/base.zsh`
- Add `ai::rtk::install` public wrapper in `zsh/modules/ai/pkg/helper.zsh`
- Add `AI_RTK_BIN_PATH` variable in `zsh/modules/ai/config/base.zsh`
- Wire `ai::internal::rtk::load` into `zsh/modules/ai/internal/main.zsh`

## Capabilities

### New Capabilities
- `rtk-install`: Install, PATH-load, and manage the `rtk` CLI tool from rtk-ai/rtk, following the same curl|sh pattern used by ollama and codegraph in the AI module.

### Modified Capabilities
<!-- No existing spec requirements are changing - this is purely additive -->

## Impact

- **Affected files:**
  - `zsh/modules/ai/config/base.zsh` — new URL/path vars, extend AI_TOOLS
  - `zsh/modules/ai/internal/base.zsh` — new installer + PATH loader
  - `zsh/modules/ai/internal/main.zsh` — wire rtk load
  - `zsh/modules/ai/pkg/helper.zsh` — public wrapper function
- **No breaking changes.** Purely additive.
- **No new dependencies.** Uses `curl` and `sh` (already required by the module).

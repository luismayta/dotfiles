## Why

The `zsh/modules/ai/` module currently supports AI tools like opencode, ollama, fabric, shimmy, hf, openclaw, and tmuxai. **jcode** (https://github.com/1jehuang/jcode) is a high-performance AI harness written in Rust, known for RAM efficiency and features like memory system, swarm multi-agent, OAuth providers, and browser automation. Adding jcode extends the AI module's tool coverage and provides users with another lightweight, efficient AI coding option.

## What Changes

- Add `config/jcode.zsh` with environment variables (ROOT_PATH, BIN_PATH, CONFIG_PATH, INSTALL_URL)
- Add `internal/jcode.zsh` with private functions: `ai::internal::jcode::load`, `ai::internal::jcode::install`, `ai::internal::jcode::sync`
- Add `pkg/jcode.zsh` with public API functions: `editjcode`, `ai::jcode::install`, `ai::jcode::sync`
- Register jcode in `config/base.zsh` (source + ZSH_AI_TOOLS array)
- Register jcode in `internal/main.zsh` (source + load call)
- Register jcode in `pkg/main.zsh` (source)
- No changes to `plugin.zsh` (already chains config → internal → pkg)

## Capabilities

### New Capabilities

- `jcode-ai-tool`: Integration of jcode as an AI tool in the zsh/modules/ai/ module, following the established three-layer architecture pattern (config/internal/pkg)

### Modified Capabilities

<!-- No existing capabilities are modified — this is a pure addition -->

## Impact

- **Files created**: `zsh/modules/ai/config/jcode.zsh`, `zsh/modules/ai/internal/jcode.zsh`, `zsh/modules/ai/pkg/jcode.zsh`
- **Files modified**: `zsh/modules/ai/config/base.zsh`, `zsh/modules/ai/internal/main.zsh`, `zsh/modules/ai/pkg/main.zsh`
- **No breaking changes**: additive only, existing tools unaffected
- **Dependencies**: jcode installed via `curl -fsSL https://jcode.sh/install | bash`
- **Reference pattern**: `config/opencode.zsh`, `internal/opencode.zsh`, `pkg/opencode.zsh`

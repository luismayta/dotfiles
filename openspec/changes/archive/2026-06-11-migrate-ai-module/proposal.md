## Why

The `zsh-ai` module currently lives in a standalone repository (`hadenlabs/zsh-ai`) outside the dotfiles monorepo. This creates friction — AI tooling configuration (opencode, fabric, ollama) must be managed separately from the rest of the shell environment. Migrating it into `zsh/modules/ai` follows the same pattern established by `tmux` and `hyprland` modules, unifying tooling install, config sync, and helper commands under one source of truth.

## What Changes

- Migrate all zsh-ai functionality from `hadenlabs/zsh-ai` into `zsh/modules/ai/`
- Adopt the standard module structure: `plugin.zsh` → `config/` → `internal/` → `pkg/`
- Remove the standalone repo as the primary source (dotfiles becomes the source of truth)
- Keep the `core/` layer from the original (it's effectively empty — empty files for base, linux, osx)
- Port all 7 AI tool installers: opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai
- Port config sync: opencode config → `~/.config/opencode/`, fabric patterns → `~/.config/fabric/patterns/`
- Port ollama model management (list, pull, install default models)
- Port helpers: `editopencode`, `ai::opencode::*`, `ai::fabric::*`, `ai::ollama::*`, etc.
- Add `pkg/osx.zsh` and `pkg/linux.zsh` as no-op placeholders (original had them empty too)
- Data directories: `data/opencode/` (opencode JSON configs) and `data/patterns/` (253 fabric patterns)
- No modifications to existing modules or specs

## Capabilities

### New Capabilities
- `ai-install`: Install and verify 7 AI developer tools (opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai)
- `ai-config-sync`: Synchronize OpenCode configuration and Fabric AI patterns to `~/.config/`
- `ai-ollama-models`: List, pull, and install default LLM models via ollama
- `ai-helpers`: Shell helper functions for editing AI configs and managing tool installations

### Modified Capabilities

*None — this is purely additive; no existing specs are affected.*

## Impact

- **New files**: ~25 files under `zsh/modules/ai/` including the full module layer and data directories
- **Data overhead**: ~253 fabric pattern directories under `zsh/modules/ai/data/patterns/`
- **zshrc**: No change — the module auto-loads via the existing `modules/*/plugin.zsh` glob
- **Standalone repo**: Can be archived or deprecated after migration
## Why

The AI module's `config/base.zsh` is a monolithic file containing configuration variables for 12+ tools (opencode, fabric, ollama, skills, graphify, openspec, rtk, hunk, pi, etc.). This mirrors the problem that was solved in `internal/` by splitting into domain-specific files. As the module grows with new tools, maintaining a single config file becomes unwieldy and violates the domain-driven architecture established in the internal layer.

## What Changes

- Split `config/base.zsh` into domain-specific config files following the same pattern as `internal/`
- Each domain file exports only its relevant variables and paths
- `config/base.zsh` becomes a thin dispatcher that sources domain configs
- No behavioral changes — purely structural refactoring

## Capabilities

### New Capabilities

- `opencode-config`: OpenCode configuration variables and paths
- `fabric-config`: Fabric patterns and configuration
- `ollama-config`: Ollama models and paths
- `skills-config`: Agent skills repositories and skill lists
- `graphify-config`: Graphify binary path
- `openspec-config`: OpenSpec configuration (currently empty, but reserved)
- `tools-config`: Shared tool paths (shimmy, codegraph, rtk, hunk, pi, openclaw)

### Modified Capabilities

None — this is a structural refactoring with no requirement changes.

## Impact

- **Files modified**: `config/base.zsh` (refactored), 7 new domain config files
- **Files unchanged**: `config/main.zsh`, `config/linux.zsh`, `config/osx.zsh`, all `internal/` and `pkg/` files
- **Dependencies**: None — no external changes
- **Breaking changes**: None — all exported variables remain identical

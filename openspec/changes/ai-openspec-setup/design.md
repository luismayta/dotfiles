## Context

OpenSpec (`@fission-ai/openspec`) is already installed as an npm package via the nodejs module and has skills/commands configured in `.opencode/skills/` and `.claude/skills/`. However, it lacks the zsh module integration that other AI tools (graphify, codegraph, rtk, etc.) have.

The existing graphify implementation in `zsh/modules/ai/` provides a proven 3-layer pattern:
- **config/base.zsh**: Environment variables (`AI_GRAPHIFY_BIN_PATH`)
- **internal/base.zsh**: Implementation functions (`ai::internal::graphify::*`)
- **pkg/helper.zsh**: Public API wrappers (`ai::graphify::*`)

OpenSpec needs the same treatment to provide consistent shell functions for install, upgrade, and project-scoped setup.

## Goals / Non-Goals

**Goals:**
- Add `AI_OPENSPEC_BIN_PATH` config variable
- Implement `ai::internal::openspec::{load,install,upgrade,setup,register_skill}` functions
- Add public wrappers `ai::openspec::{install,upgrade,setup}` in pkg/helper.zsh
- Follow the exact same pattern as graphify for consistency

**Non-Goals:**
- Modifying OpenSpec's npm installation (handled by nodejs module)
- Adding OpenSpec to the `AI_TOOLS` array (it's an npm package, not a standalone binary)
- Creating new skills or commands (already exist)

## Decisions

### 1. Follow graphify pattern exactly
**Decision**: Mirror the graphify 3-layer architecture with identical naming conventions.

**Rationale**: Consistency across the codebase reduces cognitive load. Users who understand `ai::graphify::setup` will immediately understand `ai::openspec::setup`.

**Alternatives considered**:
- Simpler single-file approach: Rejected — breaks consistency with existing tools
- Extending pkg/base.zsh: Rejected — graphify pattern is proven and well-structured

### 2. OpenSpec binary location
**Decision**: Use `$(npm root -g)/@fission-ai/openspec/bin/openspec` as the binary path, or detect via `which openspec` if already in PATH.

**Rationale**: OpenSpec is an npm global package, so its binary lives in the npm global bin directory. The `load` function should add this to PATH if not already present.

**Alternatives considered**:
- Symlink to ~/.local/bin: Rejected — adds unnecessary complexity
- Always require PATH setup: Rejected — should work out of the box

### 3. Not adding to AI_TOOLS array
**Decision**: Keep OpenSpec out of the `AI_TOOLS` auto-install list.

**Rationale**: `AI_TOOLS` is for tools installed via curl scripts. OpenSpec is installed via npm (handled by nodejs module). Adding it would cause double-installation attempts.

## Risks / Trade-offs

- **[Risk]** npm global path varies by system → **Mitigation**: Use `$(npm root -g)` dynamically instead of hardcoding
- **[Risk]** OpenSpec CLI flags may change → **Mitigation**: Follow existing `openspec` CLI patterns, document in comments
- **[Trade-off]** Slightly more complex than a simple alias → **Mitigation**: Consistency with 10+ other tools justifies the structure

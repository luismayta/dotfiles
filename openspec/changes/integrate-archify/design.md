## Context

The AI module (`zsh/modules/ai/`) manages 14 tools via a three-layer architecture: config (variables), internal (implementation), and pkg (public API). Each tool follows a consistent pattern: dedicated config file, load/install/setup functions, and namespaced public API. Archify needs to integrate as the 15th tool following this established pattern.

The module already has a skills system (`config/skills.zsh`, `internal/skills.zsh`) that bulk-installs agent skills from two repositories. Archify is installed as an agent skill via `bunx skills add tt-a1i/archify -g`.

## Goals / Non-Goals

**Goals:**
- Add Archify as a managed tool following the existing three-layer pattern
- Register Archify in the skills repo list for bulk installation
- Provide CLI wrappers for render, validate, and deliver commands
- Add shell aliases for convenience

**Non-Goals:**
- Modifying Archify's internal behavior or configuration
- Creating custom Archify renderers or schemas
- Integrating Archify with other AI tools (e.g., auto-generating diagrams from codegraph data)
- Adding Archify-specific OpenCode plugins or MCP servers

## Decisions

### Decision: Install via skills system (not direct binary)

**Choice**: Install Archify through the existing `bunx skills add` mechanism rather than downloading a standalone binary.

**Rationale**: Archify is designed as an agent skill. The skills system already handles global installation, updates, and lifecycle. Adding it to `config/skills.zsh` integrates it into the existing `ai::skills::setup` flow without duplicating install logic.

**Alternative considered**: Direct binary download via curl (like codegraph/graphify). Rejected because Archify's recommended install path is via the skills ecosystem, and this avoids maintaining a separate install mechanism.

### Decision: Thin CLI wrappers (not full abstraction)

**Choice**: Expose `ai::archify::render`, `ai::archify::validate`, `ai::archify::deliver` as thin pass-through wrappers.

**Rationale**: Archify's CLI is well-designed and stable. Wrapping it provides namespacing (`ai::archify::*`) without hiding the underlying interface. Users can still call `archify` directly if needed.

**Alternative considered**: Rich abstraction layer with input validation and output formatting. Rejected as premature — the CLI is the contract, and abstraction would add maintenance burden without clear user benefit.

### Decision: Config follows ai-config-per-tool spec

**Choice**: Create `config/archify.zsh` with `ZSH_AI_ARCHIFY_*` prefix, add to `ZSH_AI_TOOLS` registry.

**Rationale**: Follows the established `ai-config-per-tool` spec exactly. Consistency with existing tools reduces cognitive load and ensures the batch installer recognizes Archify.

## Risks / Trade-offs

**[Risk] Archify version drift** → The skills system installs the latest version. If Archify introduces breaking changes, `ai::archify::doctor` will catch issues. Users can pin versions if needed.

**[Risk] Node.js dependency** → Archify requires Node.js >= 18. This is already a dependency for other tools (bun, skills system). No additional runtime requirement.

**[Trade-off] Thin wrappers vs. rich abstraction** → We gain simplicity and maintainability at the cost of no input validation or enhanced error messages in the wrapper layer. The CLI handles its own validation.

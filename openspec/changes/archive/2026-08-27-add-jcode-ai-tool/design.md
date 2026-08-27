## Context

The `zsh/modules/ai/` module follows a three-layer architecture (config → internal → pkg) where each AI tool is implemented as a set of zsh files with consistent naming and function conventions. The reference pattern is opencode.zsh across all three layers. See proposal.md for motivation and specs/jcode-ai-tool/spec.md for requirements.

## Goals / Non-Goals

**Goals:**

- Follow the exact opencode.zsh pattern for jcode implementation
- Maintain consistency with existing AI tools in the module
- Ensure idempotent installation and config sync
- Support Linux paths: `~/.jcode/bin` (binary), `~/.jcode/` (config), `~/.config/jcode/` (system config)

**Non-Goals:**

- Adding jcode data/templates to `data/` directory (no sync templates needed initially)
- Implementing shell hooks or eval integration (jcode is a standalone CLI)
- Adding jcode to auto-install guards in `plugin.zsh`
- Cross-platform support beyond Linux (macOS can be added later)

## Decisions

### Decision: Follow opencode.zsh pattern exactly

**Choice**: Mirror the opencode.zsh implementation structure for jcode.

**Rationale**: The opencode pattern is well-established, tested, and understood by the team. Deviating would introduce inconsistency and increase cognitive load for maintainers.

**Alternatives considered**:
- Using the devops module pattern (atuin/bruno): Different prefix convention (`devops::` vs `ai::`), different module structure. Not applicable.
- Custom implementation: Higher risk of inconsistency, harder to maintain.

### Decision: curl-based installer (no package manager)

**Choice**: Use `curl -fsSL https://jcode.sh/install | bash` for installation.

**Rationale**: jcode provides an official curl installer. This matches how opencode is installed and avoids dependency on package manager availability.

**Alternatives considered**:
- `core::install jcode`: jcode is not in standard package repositories.
- Manual binary download: More complex, harder to maintain version pinning.

### Decision: No data/ directory initially

**Choice**: Skip creating `data/jcode/` and sync templates.

**Rationale**: jcode's configuration is managed by the tool itself after installation. The module only needs to ensure the tool is installed and on PATH. Sync can be added later if config templates are needed.

**Alternatives considered**:
- Creating empty data/jcode/: Adds unnecessary files.
- Pre-populating config templates: Premature without understanding jcode's config format.

### Decision: Minimal config variables

**Choice**: Export only essential variables (ROOT_PATH, BIN_PATH, CONFIG_PATH, CONFIG_SOURCE_PATH, INSTALL_URL).

**Rationale**: Follows the opencode pattern. Only variables needed by internal functions are exported. Additional variables can be added later as needed.

## Risks / Trade-offs

- **[Risk] jcode installer changes** → Mitigation: Pin to known URL, document the installer command. If jcode changes their installer, only the INSTALL_URL needs updating.
- **[Risk] Missing macOS support** → Mitigation: Document as non-goal. Can be added later with an OS-specific case block in internal/jcode.zsh.
- **[Trade-off] No auto-install in plugin.zsh** → Mitigation: Users must explicitly run `ai::jcode::install`. This is intentional — auto-install should be opt-in for new tools until proven stable.

## Context

The devops module follows a three-layer architecture (config → internal → pkg) for integrating tools with automated lifecycle management. Worktrunk is a CLI tool for managing Git worktrees, designed for parallel AI agent workflows.

Current state: The devops module has 12 tools registered in `DEVOPS_TOOLS`, including atuin, helm, k9s, and others. Each tool follows the same pattern with config variables, internal implementation functions, and public API functions.

Stakeholders: Developers using Git worktrees for parallel feature development, AI agents working on multiple tasks simultaneously.

## Goals / Non-Goals

**Goals:**
- Add worktrunk to the devops module following the established three-layer architecture
- Provide automated installation and lifecycle management
- Follow the PATH-only pattern (no shell hooks) similar to bruno
- Maintain consistency with existing tool implementations

**Non-Goals:**
- Implementing shell integration (worktrunk uses PATH-only pattern)
- Adding custom worktrunk configuration beyond installation
- Integrating with other tools in the devops module

## Decisions

### Decision: PATH-only pattern

**Choice**: Implement worktrunk using the PATH-only pattern (no shell hooks)

**Rationale**:
- Worktrunk is a standalone CLI tool that doesn't require shell initialization
- Similar to bruno in the devops module
- Simpler implementation and maintenance
- No shell integration needed for basic functionality

**Alternatives considered**:
1. **Shell hooks pattern**: Would add `eval "$(wt init zsh)"` but worktrunk doesn't provide shell hooks
2. **Custom configuration**: Would add config files but worktrunk uses standard locations

### Decision: Installation via core::install

**Choice**: Use core::install as the installation method

**Rationale**:
- core::install is the idiomatic installation function in this dotfiles system — it abstracts platform differences (brew on macOS, paru on Arch)
- Consistent with macOS development environment
- Provides automatic updates via `brew upgrade`

**Alternatives considered**:
1. **Cargo install**: More universal but requires Rust toolchain
2. **curl installer**: Less common for CLI tools in this module
3. **Brew directly**: would skip platform abstraction

### Decision: Config variable naming

**Choice**: Use `DEVOPS_WORKTRUNK_` prefix for all configuration variables

**Rationale**:
- Follows established naming convention (`DEVOPS_<TOOL>_`)
- Consistent with other tools in the module
- Clear ownership and discovery

**Alternatives considered**:
1. **WT_ prefix**: Too generic, could conflict
2. **Worktrunk_ prefix**: Inconsistent with module conventions

## Risks / Trade-offs

**Risk: Installation method availability**
- **Impact**: core::install delegates to the platform package manager (brew on macOS, paru on Arch) — if neither is available, installation fails
- **Mitigation**: Provide clear error message from core::install when package manager is unavailable

**Risk: Binary location changes**
- **Impact**: Worktrunk binary location might change between versions
- **Mitigation**: Use `core::exists` guard to verify binary availability

**Risk: PATH conflicts**
- **Impact**: Worktrunk binary might conflict with existing commands
- **Mitigation**: Use specific binary name (`wt`) and verify PATH precedence

## Migration Plan

1. Create new files: `config/worktrunk.zsh`, `internal/worktrunk.zsh`, `pkg/worktrunk.zsh`
2. Add `worktrunk` to `DEVOPS_TOOLS` array in `config/base.zsh`
3. Test module loading and function availability
4. Verify installation works on clean system

## Open Questions

1. Should we add `DEVOPS_WORKTRUNK_VERSION` to pin specific versions?
2. Should we add `DEVOPS_WORKTRUNK_SHELL_INTEGRATION` flag for future shell hooks?
3. Should we add post-install message for initial setup instructions?

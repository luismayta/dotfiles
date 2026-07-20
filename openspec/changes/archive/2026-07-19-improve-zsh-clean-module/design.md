## Context

The `zsh/modules/clean/` module currently provides cleanup utilities for terminal sessions but has significant gaps:

- **Incomplete implementations**: Linux platform functions are stubs that only warn "not implemented"
- **Code duplication**: `cleanup` and `cleanup::unnecessary` functions overlap significantly
- **No safety features**: No dry-run mode, confirmation prompts, or deletion logging
- **Hardcoded paths**: Cache and log paths aren't configurable
- **Missing modern tools**: No cleanup for rust/cargo, go modules, bun, pnpm, ccache
- **Poor integration**: Platform-specific functions exist but aren't called from main cleanup flow

The module relies on `zsh/core/` for messaging utilities (`message_info`, `message_success`, etc.) which should be leveraged consistently.

## Goals / Non-Goals

**Goals:**
- Consolidate duplicate cleanup functions into a unified interface
- Add `--dry-run` flag and confirmation prompts for safe cleanup operations
- Make cleanup paths configurable via environment variables
- Complete Linux platform implementations (trash, logs)
- Integrate all platform-specific functions into main cleanup flow
- Add support for modern development tools (rust, go, bun, pnpm, ccache, docker volumes)
- Leverage core messaging utilities throughout

**Non-Goals:**
- Changing existing function signatures (backward compatibility)
- Adding interactive TUI or complex user interfaces
- Implementing automatic scheduling or cron-based cleanup
- Supporting Windows/WSL (focus on Linux and macOS only)

## Decisions

### 1. Safety-First Architecture

**Decision**: Add `--dry-run` flag and optional confirmation prompts to all cleanup functions.

**Rationale**: Cleanup operations are destructive. Users need visibility into what will be deleted before execution.

**Alternatives Considered**:
- Separate `cleanup::dryrun` functions: Rejected - doubles code surface
- Verbose logging only: Rejected - doesn't prevent accidental deletion

### 2. Environment Variable Configuration

**Decision**: Use `CLEAN_*` environment variables for path customization (e.g., `CLEAN_PIP_CACHE_PATH`).

**Rationale**: Follows existing pattern in core module; allows user customization without modifying module code.

**Implementation**:
```zsh
# Example configuration
export CLEAN_PIP_CACHE_PATH="${HOME}/.cache/pip"
export CLEAN_NPM_CACHE_PATH="${HOME}/.npm"
export CLEAN_DRY_RUN=false
export CLEAN_CONFIRM=true
```

### 3. Modular Function Design

**Decision**: Keep existing function signatures but consolidate internal logic.

**Rationale**: Maintains backward compatibility while reducing code duplication.

**Implementation**:
- `cleanup::unnecessary` becomes internal helper called by `cleanup`
- `cleanup::all` calls platform-specific functions based on OS detection
- New functions added to `pkg/base.zsh` for modern tools

### 4. Platform Detection Pattern

**Decision**: Use `case "${OSTYPE}"` pattern already established in module structure.

**Rationale**: Consistent with existing codebase; no new dependencies.

**Implementation**:
- `pkg/linux.zsh`: Implement actual trash/log cleanup using `trash-cli` or manual deletion
- `pkg/osx.zsh`: Keep existing implementations, integrate into main flow

### 5. Core Utility Integration

**Decision**: Replace all inline message functions with core equivalents.

**Rationale**: Consistent messaging, reduced code duplication, leverages existing infrastructure.

**Implementation**:
- `message_info` → `core::internal::message::info`
- `message_success` → `core::internal::message::success`
- `message_warning` → `core::internal::message::warning`
- `message_error` → `core::internal::message::error`

## Risks / Trade-offs

### Risk 1: Breaking Existing Workflows

**Risk**: Users may have scripts依赖 on current function behavior.

**Mitigation**: 
- Preserve all existing function signatures
- Add new flags as optional parameters
- Default behavior unchanged (dry-run requires explicit flag)

### Risk 2: Platform-Specific Complexity

**Risk**: Linux implementations may vary across distributions.

**Mitigation**:
- Check for tool availability before use (e.g., `trash-cli`)
- Fall back to manual deletion with warnings
- Document required tools in README

### Risk 3: Performance Impact

**Risk**: Confirmation prompts may slow down batch operations.

**Mitigation**:
- Make confirmation optional via `CLEAN_CONFIRM=false`
- Add `--force` flag to skip all prompts
- Optimize find commands with proper exclusions

### Trade-off: Safety vs. Convenience

**Decision**: Default to safe mode (dry-run, confirmation) with opt-out.

**Rationale**: Destructive operations should require explicit consent. Users can disable via environment variables for automation.

## Migration Plan

### Phase 1: Core Refactoring (No Breaking Changes)
1. Consolidate `cleanup::unnecessary` into `cleanup`
2. Replace message functions with core equivalents
3. Add environment variable support for existing paths

### Phase 2: Safety Features
1. Add `--dry-run` flag parsing to main functions
2. Implement confirmation prompts
3. Add deletion logging

### Phase 3: Platform Completion
1. Implement Linux trash/log cleanup
2. Integrate platform-specific functions into `cleanup::all`
3. Add modern tool cleanup functions

### Rollback Strategy
- Keep original functions as deprecated wrappers
- Environment variables allow disabling new features
- Module can be disabled via `ZSH_CLEAN_ENABLED=false`

## Open Questions

1. **Confirmation Prompt Style**: Should we use simple y/n or numbered menu?
2. **Logging Destination**: File logging or just stdout?
3. **Docker Cleanup Scope**: Include Docker images, containers, volumes, or all?
4. **Default Behavior**: Should dry-run be default or require explicit flag?

## Context

The AI tools module (`/home/lucho/.dotfiles/zsh/modules/ai/`) contains three main tools that need standardized lifecycle management:

1. **openspec** - Complete implementation with init, install, setup, update, upgrade
2. **graphify** - Missing init and update functions
3. **codegraph** - Only has install function, missing init, setup, update, upgrade

Current architecture uses a two-layer pattern:
- `pkg/` - Public API functions that delegate to internal implementations
- `internal/` - Actual implementation with tool-specific logic

## Goals / Non-Goals

**Goals:**
- Standardize all three tools to have identical interface: init, install, setup, update, upgrade
- Maintain consistency with existing openspec implementation pattern
- Ensure proper error handling and user feedback
- Keep the two-layer architecture (pkg/internal) intact

**Non-Goals:**
- Refactor other AI tools (shimmy, hf, openclaw, etc.)
- Change the underlying installation mechanisms for each tool
- Modify the config or data directories
- Add new tools to the module

## Decisions

### Decision 1: Follow openspec's implementation pattern

**Choice**: Use openspec as the reference implementation for all tools.

**Rationale**: 
- Openspec already has a complete, working implementation
- Consistent pattern reduces cognitive load for maintenance
- Proven error handling and user feedback approach

**Alternatives considered**:
- Create unique implementations for each tool: Rejected due to maintenance overhead
- Use a generic framework: Over-engineered for this use case

### Decision 2: Keep tool-specific installation logic

**Choice**: Each tool maintains its own installation method (bun, uv, curl).

**Rationale**:
- Different tools have different package managers
- Installation logic is already working and tested
- Avoids unnecessary abstraction

**Alternatives considered**:
- Unify installation under one package manager: Would require rewriting working code

### Decision 3: Add missing functions incrementally

**Choice**: Add init, update, and upgrade functions to graphify and codegraph one at a time.

**Rationale**:
- Easier to test each function separately
- Reduces risk of breaking existing functionality
- Allows for incremental validation

## Risks / Trade-offs

### Risk 1: Breaking existing functionality
**Mitigation**: Test each function individually after implementation. Keep existing functions unchanged while adding new ones.

### Risk 2: Inconsistent behavior between tools
**Mitigation**: Follow openspec's pattern exactly. Use the same error messages and success messages format.

### Risk 3: Missing tool-specific requirements
**Mitigation**: Research each tool's capabilities before implementing init/update functions. Some tools may not support certain operations.

## Migration Plan

1. **Phase 1**: Add missing functions to graphify (init, update)
2. **Phase 2**: Add missing functions to codegraph (init, setup, update, upgrade)
3. **Phase 3**: Update pkg/ files to expose new functions
4. **Phase 4**: Test all functions individually
5. **Phase 5**: Update batch install if needed

**Rollback**: Revert changes to pkg/ and internal/ files if issues arise.

## Open Questions

1. Does graphify support an `init` command similar to openspec?
2. Does codegraph support `setup`, `update`, and `upgrade` commands?
3. Should we add a `register_skill` function to codegraph like openspec and graphify have?
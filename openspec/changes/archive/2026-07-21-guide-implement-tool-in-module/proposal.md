## Why

The devops module has a consistent three-layer architecture (config → internal → pkg) for integrating tools, but there's no documentation explaining this pattern. New contributors or when adding tools, developers must reverse-engineer existing implementations like atuin to understand conventions. A guide codifies the pattern and accelerates tool integration.

## What Changes

- New documentation file at `docs/guides/implement-tool-in-module.md`
- Guide covers the complete lifecycle: config variables, internal logic, public API, and registration
- Uses atuin as the reference implementation with annotated code examples
- Documents the naming conventions, guard patterns, and auto-install behavior

## Capabilities

### New Capabilities

- `tool-implementation-guide`: Documentation guide explaining how to implement a new tool in the devops module following the established three-layer architecture pattern

### Modified Capabilities

<!-- No existing capabilities are being modified -->

## Impact

- **Files created**: `docs/guides/implement-tool-in-module.md`
- **No code changes**: This is documentation only
- **No dependencies added**: Pure markdown documentation
- **Scope**: Developer-facing documentation for the devops module

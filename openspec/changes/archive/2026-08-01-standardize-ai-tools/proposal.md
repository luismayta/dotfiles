## Why

The AI tools (openspec, graphify, codegraph) have inconsistent interfaces for lifecycle management. Openspec has a complete set of functions (init, install, setup, update, upgrade), while graphify is missing init and update, and codegraph only has install. This inconsistency creates confusion and makes it harder to maintain and extend the tools.

## What Changes

- Add missing `init` function to graphify and codegraph
- Add missing `update` function to graphify and codegraph
- Add missing `upgrade` function to codegraph
- Standardize all three tools to follow the same interface pattern
- Ensure consistent error handling and user feedback across all tools

## Capabilities

### New Capabilities

- `tool-lifecycle-standardization`: Standardized interface for AI tool lifecycle management (init, install, setup, update, upgrade)

### Modified Capabilities

- `graphify-management`: Add init and update functions to graphify tool management
- `codegraph-management`: Add init, setup, update, and upgrade functions to codegraph tool management

## Impact

- **Affected Code**: 
  - `/home/lucho/.dotfiles/zsh/modules/ai/pkg/graphify.zsh`
  - `/home/lucho/.dotfiles/zsh/modules/ai/pkg/tools.zsh`
  - `/home/lucho/.dotfiles/zsh/modules/ai/internal/graphify.zsh`
  - `/home/lucho/.dotfiles/zsh/modules/ai/internal/tools.zsh`
- **Dependencies**: No new dependencies required
- **Systems**: ZSH shell functions for AI tool management
## Why

Static analysis of all `.sh`/`.zsh` function calls vs definitions revealed 3 functions being called with incorrect names — typos and wrong namespaces — that cause runtime "command not found" errors. These are straightforward bugs that block normal module operation.

## What Changes

- **zsh/modules/starship/pkg/base.zsh**: Fix function call `starship::internal::starship::install` → `starship::internal::install` (extra `::starship` namespace segment)
- **zsh/modules/devops/pkg/kubectl.zsh**: Fix function call `Goenv::internal::package::install` → `goenv::internal::package::install` (capital `G` typo)
- **zsh/modules/devops/internal/kubectl.zsh`: Fix function call `goenv::internal::package::get` → replace with correct existing function or implementation

## Capabilities

### New Capabilities
- `function-name-validation`: Verify all function calls in the codebase resolve to existing definitions (automated check to prevent regression)

### Modified Capabilities
None — these are bug fixes, not requirement changes.

## Impact

- `zsh/modules/starship/pkg/base.zsh` — fixes starship auto-install flow
- `zsh/modules/devops/pkg/kubectl.zsh` — fixes kubectl go package install flow
- `zsh/modules/devops/internal/kubectl.zsh` — fixes kubectl internal package install flow
- No new dependencies introduced
- No breaking changes
## Why

The `direnv` tool is currently fragmented across the codebase: its shell hook lives in `zsh/system/core/internal/direnv.zsh`, the nix-direnv plugin setup in `zsh/system/nix/internal/direnv.zsh`, and its config template inside `zsh/system/nix/data/sync/.config/direnv/direnvrc`. This scattering breaks the three-layer architecture pattern (config/internal/pkg) and makes the tool harder to maintain, test, and evolve. Extracting direnv into its own proper module structure eliminates this cross-module coupling and brings it in line with the established tool implementation guide.

## What Changes

1. **Create a new `direnv` tool module** following the three-layer architecture (config/internal/pkg) as specified in `docs/guides/implement-tool-in-module.md`.
2. **Move direnv shell hook** from `zsh/system/core/internal/direnv.zsh` into the new module's internal layer.
3. **Move nix-direnv plugin setup** from `zsh/system/nix/internal/direnv.zsh` into the new module.
4. **Move direnvrc config template** from `zsh/system/nix/data/sync/.config/direnv/direnvrc` into the new module's data directory.
5. **Clean up** references in `zsh/system/nix/internal/main.zsh` (remove `source` and `nix::internal::direnv::setup` call).
6. **Clean up** references in `zsh/system/core/` (remove or redirect the existing direnv hook file).
7. **Fix nix config sync** — remove the direnvrc from nix's data/sync/ so nix no longer owns direnv configuration.
8. **Restructure nix data directory** — replace the generic `data/sync/` (synced to `$HOME/`) with a targeted `data/nix/` that syncs nix-specific config files (e.g., `nix.conf`) to `~/.config/nix/`.

## Capabilities

### New Capabilities
- `direnv-tool`: A self-contained direnv module with proper config variables, internal implementation (load/install/upgrade), and public API, following the tool implementation guide.

### Modified Capabilities
- *(none — no existing specs need requirement changes)*

## Impact

- **Files removed:** `zsh/system/core/internal/direnv.zsh`, `zsh/system/nix/internal/direnv.zsh`, `zsh/system/nix/data/sync/.config/direnv/direnvrc`
- **Files created:** New module directory with `config/`, `internal/`, `pkg/`, `data/` for direnv
- **Existing spec changes:** None (direny tool is a new capability, not a spec-level behaviour change)
- **Breaking:** The `nix::internal::direnv::setup` function will be removed — any external callers must migrate to the new API

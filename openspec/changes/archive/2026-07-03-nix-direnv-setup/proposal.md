## Why

Every `git status` inside a flake-based project triggers a direnv reload because `use flake` (built-in) watches `flake.nix`/`flake.lock` and re-evaluates the dev shell on every prompt. This adds 2-5s latency per shell interaction and surfaces dirty Git tree warnings from Nix. The root cause is that direnv's built-in `use_flake` has no caching — `nix-direnv` solves this by caching the dev shell evaluation, reducing reloads to ~0.1s.

This change installs `nix-direnv` as a global direnv plugin so all projects using `use flake` benefit from caching, without modifying any project-level `.envrc`.

## What Changes

- Add `nix-direnv` package installation via `nix profile` in the nix module's internal setup
- Create the global direnv config `~/.config/direnv/direnvrc` that sources `nix-direnv`'s plugin
- Ensure the direnv config directory exists as part of module bootstrap
- No changes to any `.envrc` files — `use flake` continues to work transparently

## Capabilities

### New Capabilities
- `nix-direnv-setup`: Install and configure nix-direnv as a global direnv plugin. Handles package installation via `nix profile`, direnv config directory creation, and sourcing the nix-direnv plugin in `direnvrc`.

### Modified Capabilities
*(None — no existing specs are changing)*

## Impact

- **New dependency**: `nixpkgs#nix-direnv` installed via `nix profile`
- **New file**: `~/.config/direnv/direnvrc` — global direnv config sourcing nix-direnv
- **Module area**: `zsh/modules/nix/internal/` — new setup logic for nix-direnv
- **All flake projects**: benefit from cached dev shell evaluation automatically

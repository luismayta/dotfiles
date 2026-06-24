## Why

<!-- Explain the motivation for this change. What problem does this solve? Why now? -->

Wezterm is the primary terminal emulator on this system, with a modular Lua configuration stored on an external drive (`/run/media/lucho/Jasper/.config/wezterm`). Currently there is no ZSH module to manage its installation, sync configuration from the data source to `~/.config/wezterm/`, or provide shell-level convenience commands. Adding a module following the established `modules/` convention ensures consistent config management, auto-install, and a predictable user API.

## What Changes

<!-- Describe what will change. Be specific about new capabilities, modifications, or removals. -->

- Create `zsh/modules/wezterm/` with full three-layer architecture (config, internal, pkg)
- Implement config sync from `ZSH_WEZTERM_DATA_PATH` → `~/.config/wezterm/` via rsync
- Provide public API: `wezterm::install`, `wezterm::sync`, `wezterm::setup`
- Add alias `editwezterm` to open the module data path in VS Code
- Auto-install wezterm binary via `core::ensure` if not present
- Populate `data/` directory with wezterm config files from the external data source

## Capabilities

### New Capabilities
<!-- Capabilities being introduced. Replace <name> with kebab-case identifier (e.g., user-auth, data-export, api-rate-limiting). Each creates specs/<name>/spec.md -->
- `wezterm-module`: ZSH module for wezterm terminal management — install, config sync, and shell integration

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use existing spec names from openspec/specs/. Leave empty if no requirement changes. -->


## Impact

<!-- Affected code, APIs, dependencies, systems -->

- New directory: `zsh/modules/wezterm/` (~16 files)
- New data files under `zsh/modules/wezterm/data/` synced from wezterm config source
- The module loader will auto-source via `zsh/modules/` convention (no zshrc change needed)
- No breaking changes to existing modules or specs

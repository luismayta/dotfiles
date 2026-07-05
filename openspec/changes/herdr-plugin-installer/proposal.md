## Why

The herdr module currently manages the herdr binary itself (install, sync, workspace management) but has no support for installing herdr plugins. The herdr ecosystem has a rich and growing plugin marketplace — including `herdr-insight` (agent timeline), `herdr-pm` (AI technical PM), `herdr-mcp` (MCP server), `herdr-codex-usage-kit`, `git-wt-herdr`, and many more listed in the [awesome-herdr](https://github.com/yigitkonur/awesome-herdr) index. Users should be able to declare and install plugins declaratively, mirroring the package install pattern already established in the goenv module, rather than manually cloning repos and running `herdr plugin install`.

## What Changes

- Add `ZSH_HERDR_INSTALL_PLUGINS` array in `config/base.zsh` listing desired herdr plugins (GitHub shorthand format)
- Add plugin management functions in `internal/base.zsh`: install, list installed, update, uninstall
- Add thin public API wrappers in `pkg/base.zsh`
- Add `pkg/helper.zsh` with user-facing interactive helpers (`hrd::plugin`) for fzf-based plugin management
- Auto-install configured plugins during module load (after herdr binary is confirmed present)
- Add `data/` plugin descriptor stubs for documentation purposes

## Capabilities

### New Capabilities
- `plugin-install`: Install herdr plugins from GitHub shorthand (e.g., `0x5c0f/herdr-insight`) via `herdr plugin install`, with support for bulk install from config array
- `plugin-list`: List currently installed plugins via `herdr plugin list`
- `plugin-update`: Reinstall/update a specific plugin or all configured plugins
- `plugin-uninstall`: Remove a plugin via `herdr plugin uninstall`
- `plugin-interactive`: FZF-based interactive plugin selector for install/list/uninstall operations

### Modified Capabilities

*(None — no existing specs are changing.)*

## Impact

- **Module**: `zsh/modules/herdr/` — additions to `config/base.zsh`, `internal/base.zsh`, `pkg/base.zsh`, new `pkg/helper.zsh`
- **No external API changes**: all new functions follow existing naming conventions (`herdr::plugin::*`, `herdr::internal::plugin::*`)
- **No breaking changes**: existing functionality unchanged

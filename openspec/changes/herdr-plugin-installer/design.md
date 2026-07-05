## Context

The herdr module is structured in the standard 3-layer architecture used across this dotfiles repo: `config/` (env vars), `internal/` (private implementation), and `pkg/` (public API + helpers). It currently handles herdr binary installation, config sync, and workspace management but has no plugin management support.

The goenv module provides the established pattern: a `GOENV_INSTALL_PACKAGES` array in `config/base.zsh` + `internal::package::install` + `internal::packages::install` + public wrappers in `pkg/base.zsh`. This design replicates that pattern for herdr plugins, replacing `go install` with `herdr plugin install`.

Herdr plugins use GitHub shorthand notation (`owner/repo` or `owner/repo/subdir`) and are installed via `herdr plugin install <shorthand>`. The [awesome-herdr](https://github.com/yigitkonur/awesome-herdr) index catalogs dozens of community plugins.

## Goals / Non-Goals

**Goals:**
- Declarative plugin list via `ZSH_HERDR_INSTALL_PLUGINS` array in `config/base.zsh`
- Bulk install of all configured plugins during module load
- Individual plugin install/list/update/uninstall functions
- FZF-based interactive plugin management (`hrd::plugin`)
- Follow goenv package conventions exactly for naming and structure

**Non-Goals:**
- Plugin development scaffolding (creating new plugins)
- Plugin marketplace browsing or discovery (out of scope — use awesome-herdr or `herdr plugin list`)
- Version pinning (herdr CLI handles this)
- Dependency resolution between plugins

## Decisions

1. **Config array pattern**: `ZSH_HERDR_INSTALL_PLUGINS` as a flat array of GitHub shorthand strings, matching `GOENV_INSTALL_PACKAGES` in goenv. Each entry is an installable shorthand like `0x5c0f/herdr-insight`.

2. **Function naming**: Follow goenv conventions exactly:
   - `herdr::internal::plugin::install <shorthand>` — install one plugin
   - `herdr::internal::plugin::install::all` — install all from config array
   - `herdr::internal::plugin::list` — list installed plugins
   - `herdr::internal::plugin::update <shorthand>` — update/reinstall one
   - `herdr::internal::plugin::uninstall <shorthand>` — remove one
   - Public wrappers: `herdr::plugin::install`, `herdr::plugin::list`, etc.
   - Interactive: `hrd::plugin` in `pkg/helper.zsh` (like `hrd` and `hrdk`)

3. **Auto-install timing**: After herdr binary is confirmed installed in `internal/main.zsh`, loop through `ZSH_HERDR_INSTALL_PLUGINS` and install any missing plugins. Skip if array is empty.

4. **Guards**: Each `herdr plugin` function checks that the herdr binary exists before proceeding, with a clear error message if missing.

5. **Default plugins**: The array will be empty by default — users opt in by adding entries. A commented example line documents the format.

## Risks / Trade-offs

- **[herdr CLI not installed]** → Functions check `core::exists herdr` before calling herdr commands; auto-install in `internal/main.zsh` handles this upstream.
- **[Plugin shorthand changes upstream]** → Users update the shorthand in the config array; we can't control upstream repository moves.
- **[herdr plugin install is non-deterministic]** → It clones from GitHub each time; mitigated by only installing missing plugins (not reinstalling on every load).
- **[Config array grows large]** → No performance concern — the loop is cheap; herdr CLI handles deduplication.

## Context

The yazi module (`zsh/modules/yazi/`) currently manages a single config file — `theme.toml` — downloaded from catppuccin/yazi and synced to `~/.config/yazi/` via `yazi::internal::config::sync`. There is no plugin, linemode, or general yazi.toml configuration.

The reference config (JAEHEONJI/dotfiles) demonstrates three additional files:
- `package.toml` — declares plugin dependencies for yazi's built-in package manager
- `init.lua` — loads plugins and implements a custom linemode
- `yazi.toml` — sets `linemode = "custom"` and other manager preferences

The module's sync mechanism already exists; the change is additive — place these files in `data/` and let the existing `rsync` pick them up. No structural changes to the module architecture are needed.

## Goals / Non-Goals

**Goals:**
- Ship `package.toml`, `init.lua`, and `yazi.toml` alongside the existing `theme.toml`
- The custom linemode renders "size permissions mtime" for each file entry
- Plugin dependencies are pinned to specific revisions for reproducibility
- All files land in `~/.config/yazi/` on the next `yazi::sync`

**Non-Goals:**
- No new config variables exposed in `config/base.zsh` — the yazi.toml and init.lua are static
- No automatic plugin installation at shell level — yazi handles this on first launch via package.toml
- No changes to the install or setup orchestrator logic
- No theme customization beyond what already exists

## Decisions

1. **Static config files over template generation.** yazi.toml, package.toml, and init.lua are small, well-known files with no user-specific content. Storing them as static assets in `data/` is simpler than generating them in `internal/base.zsh`. They ship as-is on every sync.

2. **Pin plugin revisions.** The reference pins `full-border` and `no-status` to `c2c16c8` and `starship` to `a837101`. We keep these pins for reproducibility. If plugins break, yazi shows a clear error and the user bumps the rev.

3. **Separate specs for plugin setup vs config settings.** `yazi-plugin-setup` covers package.toml + init.lua; `yazi-config-settings` covers yazi.toml. Keeps concerns clean if only one side needs changes later.

4. **Custom linemode naming.** Uses `linemode = "custom"` in yazi.toml, which maps to `Linemode:custom()` in init.lua. The linemode renders `<size> <rwx-perms> <mtime>` with Catppuccin-colored permission characters.

5. **Indicator padding from reference.** The reference theme.toml sets `[indicator] padding = { open = "▐", close = "▌" }`. Since our theme is already a full catppuccin theme, this specific styling is better handled there. However, it's small enough that adding it to our existing theme.toml is reasonable.

## Risks / Trade-offs

- **Plugin revision pin drift.** Pinned revs may become incompatible with newer yazi versions.
  → Mitigation: yazi warns on mismatch; updates are a trivial rev bump in package.toml.
- **init.lua errors break yazi on startup.** A Lua error in init.lua prevents yazi from launching.
  → Mitigation: the init.lua is minimal (<60 lines) and well-tested. Start yazi with `--debug` to diagnose.
- **Overwriting user's existing config files.** If the user has their own yazi.toml or init.lua, `yazi::sync` will overwrite them.
  → Mitigation: this is existing behavior for theme.toml. Users opt into the module's sync.

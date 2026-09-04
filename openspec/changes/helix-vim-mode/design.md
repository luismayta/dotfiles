## Context

The helix module at `zsh/modules/helix/` manages Helix editor installation, configuration sync, and grammar management. The configuration lives in `data/config.toml` and is synced to `~/.config/helix/config.toml`. Currently, the config has basic settings (theme, editor options, window navigation) but no vim-mode keybindings.

Helix uses TOML-based key remapping via `[keys.normal]`, `[keys.insert]`, and `[keys.select]` sections. It supports:
- Static commands (e.g., `move_char_right`)
- Typable commands (e.g., `:write`)
- Macros (e.g., `@miw`)
- Custom minor modes via nested key definitions

## Goals / Non-Goals

**Goals:**
- Add vim-style keybindings for normal mode (word nav, line ops, paste/yank)
- Implement `jj`/`jk` to exit insert mode
- Create ',' leader key with quick command sequences (save, quit, file picker, find)
- Preserve Helix's native selection-mode functionality
- Keep configuration maintainable in `data/config.toml`

**Non-Goals:**
- Full Vim emulation (Helix's selection-first philosophy differs fundamentally)
- Override Helix's native keybindings (additive only)
- Add leader key to insert or select modes (normal mode only)

## Decisions

### Decision 1: Use Helix's native key remapping (not a fork)
**Choice**: Configure via `config.toml` keybindings
**Alternatives considered**:
- Fork Helix with vim mode (LGUG2Z/helix-vim) - Rejected: maintenance burden, diverges from upstream
- Use external key remapper (e.g., skhd) - Rejected: can't intercept Helix's internal modes

**Rationale**: Helix's TOML config supports all needed features. Staying with native config avoids fork maintenance.

### Decision 2: ',' as leader key via custom minor mode
**Choice**: Create `[keys.normal.","]` minor mode for leader sequences
**Alternatives considered**:
- Use `Space` as leader - Rejected: conflicts with Helix's space mode (file picker, diagnostics)
- Use `;` as leader - Rejected: conflicts with repeat f/F/t/T
- Use `Ctrl` combinations - Rejected: harder to type, less vim-familiar

**Rationale**: `,` is available in Helix's normal mode and matches vim leader convention. Creating a minor mode under `[keys.normal.","]` allows multi-key sequences.

### Decision 3: jj/jk via keys.insert mappings
**Choice**: Map `j` with nested `k`/`j` in `[keys.insert]`
**Alternatives considered**:
- Use `Escape` only - Rejected: less ergonomic for vim users
- Use `Ctrl-[` - Rejected: less familiar

**Rationale**: Standard vim exit pattern. Helix supports nested key definitions in insert mode.

### Decision 4: dd/yy as macros (not native commands)
**Choice**: Implement `dd` and `yy` as macro sequences (`@d` and `@y`)
**Alternatives considered**:
- Map directly to `delete_line`/`yank_line` - Rejected: Helix doesn't have direct equivalents
- Use `Space` mode commands - Rejected: adds unnecessary keystrokes

**Rationale**: Helix's `d` and `y` are operators that work on selections. Macros `@d` (select line, delete) and `@y` (select line, yank) replicate vim behavior.

## Risks / Trade-offs

**[Risk] Keybinding conflicts** → Mitigation: Test all bindings; document overrides. Users can disable via `no_op`.

**[Risk] Macro limitations** → Mitigation: Macros can't be nested in sequences. Keep leader commands simple.

**[Risk] Helix upstream changes** → Mitigation: Pin helix version in config; review changelog for keybinding changes.

**[Trade-off] Full vim emulation impossible** → Accepted: Helix's architecture differs fundamentally. Focus on most-used vim patterns.

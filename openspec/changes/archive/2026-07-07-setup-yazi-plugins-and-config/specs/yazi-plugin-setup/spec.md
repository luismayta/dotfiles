## ADDED Requirements

### Requirement: package.toml declares plugin dependencies
The system SHALL ship a `package.toml` in `~/.config/yazi/` that declares the following plugin dependencies:

| Plugin | Repository | Pinned Revision |
|--------|-----------|-----------------|
| full-border | yazi-rs/plugins:full-border | `c2c16c8` |
| no-status | yazi-rs/plugins:no-status | `c2c16c8` |
| starship | Rolv-Apneseth/starship | `a837101` |

The package.toml SHALL also declare a flavor dependency with revision pinning:
| Flavor | Repository | Pinned Revision |
|--------|-----------|-----------------|
| catppuccin-mocha | yazi-rs/flavors:catppuccin-mocha | `36c49ac` |

#### Scenario: package.toml exists after sync
- **WHEN** `yazi::sync` completes
- **THEN** `~/.config/yazi/package.toml` SHALL contain the three plugin entries with their pinned revisions and hashes

#### Scenario: yazi resolves plugins on launch
- **WHEN** yazi starts in `~/.config/yazi/`
- **THEN** yazi SHALL download and activate full-border, no-status, and starship plugins according to package.toml

### Requirement: init.lua loads plugins and defines custom linemode
The system SHALL ship an `init.lua` in `~/.config/yazi/` that:

1. Loads the `full-border`, `no-status`, and `starship` plugins via `require()`
2. Defines a custom linemode named `custom` that renders each file entry in the format:
   `<size> <permissions> <mtime>`
3. Permission characters (`rwx`) SHALL use Catppuccin colors:
   - `r` → `#f9e2af` (yellow)
   - `w` → `#f38ba8` (red)
   - `x` → `#a6e3a1` (green)
   - `-` → `#585b70` (surface2)
4. Colors SHALL be suppressed on hovered rows to preserve selection highlight readability

#### Scenario: init.lua exists after sync
- **WHEN** `yazi::sync` completes
- **THEN** `~/.config/yazi/init.lua` SHALL exist with the plugin requires and linemode implementation

#### Scenario: custom linemode renders correctly
- **WHEN** a file entry is displayed with `linemode = "custom"`
- **THEN** the output SHALL be `<size> <colored_permissions> <mtime>` for non-hovered rows

#### Scenario: permissions are monochrome on hovered row
- **WHEN** a file entry is hovered in the active pane
- **THEN** permission characters SHALL use default (uncolored) style to maintain selection highlight contrast

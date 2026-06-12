## ADDED Requirements

### Requirement: Declarative app launcher bind table

The system SHALL provide a declarative data table `configs/binds/apps.lua` that defines application launcher keybindings as structured entries, following the Hammerspoon `config.apps[]` pattern.

Each entry SHALL contain:
- `mods`: array of modifier keys (e.g., `{ "SUPER", "ALT", "CTRL" }`)
- `key`: the primary key (e.g., `"T"`, `"RETURN"`)
- `exec`: the command string to execute (e.g., `"kitty"`, `"zen-browser"`)
- `opts`: optional table of additional bind options (e.g., `{ repeating = true }`)

#### Scenario: App launcher bind executes on keypress
- **WHEN** the user presses the combination defined in an app launcher entry
- **THEN** the system executes the specified `exec` command

#### Scenario: App launcher entry with no opts uses defaults
- **WHEN** an app launcher entry does not include an `opts` field
- **THEN** the bind is registered with Hyprland's default options (no repeating, no mouse, etc.)

### Requirement: Three-tier modifier convention

The app launcher binds SHALL use three modifier tiers for semantic grouping:

| Tier | Modifier | Purpose |
|------|----------|---------|
| Hyper (dev tools) | `SUPER + ALT + CTRL` | IDEs, terminal, database, development tools |
| Secondary (system) | `SUPER + ALT` | Browsers, communication apps, system utilities |
| Tertiary (actions) | `SUPER + CTRL` | Screenshots, clipboard, quick actions |

#### Scenario: Hyper tier launches dev tools
- **WHEN** the user presses `SUPER + ALT + CTRL + T`
- **THEN** the system launches Ghostty terminal

#### Scenario: Secondary tier launches system apps
- **WHEN** the user presses `SUPER + ALT + A`
- **THEN** the system launches Zen browser

### Requirement: Mnemonic key mapping

App launcher keys SHOULD follow mnemonic mapping where practical:
- First letter of the application name (e.g., `O` for Obsidian, `Z` for Zoom)
- Abbreviation where first letter conflicts (longest unique prefix wins)
- Documented in a comment block at the top of `apps.lua`

#### Scenario: Mnemonic key launches expected app
- **WHEN** the user presses the mnemonic key combination for an app
- **THEN** the expected application launches

### Requirement: Hammerspoon parity table

The app launcher bind table SHALL include all apps from the Hammerspoon `config.apps` list (30 entries) that have a Linux equivalent, mapped to their appropriate modifier tier:

- **Hyper tier**: Android Studio (`[`), IntelliJ IDEA (`]`), Zed (`;`), Bitwarden (`B`), draw.io (`D`), Ghostty (`T`), Insomnia (`I`), DataGrip (`S`), Keybase (`K`), Jira (`J`), Obsidian (`O`), Zoom (`Z`)
- **Secondary tier**: Zen (`A`), Comet (`C`), Discord (`D`), Figma (`F`), WhatsApp (`H`), Telegram (`T`), Spotify/Music (`M`), Dolphin (`O`), System tools (where Linux equivalents exist)
- **Tertiary tier**: Screenshot region (`P`), Screenshot full (`CTRL + P`), Clipboard (`V`)

#### Scenario: All hammerspoon apps have hyprland equivalents where possible
- **WHEN** reviewing the app launcher table
- **THEN** every app from the Hammerspoon config with a Linux equivalent appears in the table

### Requirement: Existing app binds preserved

The existing app launcher binds (kitty, kitty-float, zen-browser, dolphin) SHALL be migrated to the declarative table with updated applications:
- `SUPER + RETURN` → Ghostty (replaces kitty)
- `SUPER + SHIFT + RETURN` → Ghostty float (replaces kitty-float)  
- `SUPER + B` → Zen browser (replaces zen-browser)
- `SUPER + E` → Dolphin (unchanged)

#### Scenario: Legacy app bind migrated
- **WHEN** the user presses `SUPER + RETURN`
- **THEN** Ghostty launches (updated from kitty)

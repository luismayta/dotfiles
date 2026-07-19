## ADDED Requirements

### Requirement: Custom modules live in data/scripts/
All custom module scripts SHALL be placed in `zsh/modules/waybar/data/scripts/` and synced to `~/.config/waybar/scripts/`.

#### Scenario: Scripts are synced to correct path
- **WHEN** `waybar::sync` runs
- **THEN** all files in `data/scripts/` exist in `~/.config/waybar/scripts/` with same permissions

### Requirement: Scripts are executable
All custom module scripts MUST be executable (`chmod +x`).

#### Scenario: Scripts have correct permissions after sync
- **WHEN** a script is synced to `~/.config/waybar/scripts/`
- **THEN** the file has execute permission (`-rwxr-xr-x` or similar)

### Requirement: Custom modules use custom/* config blocks
Each custom module SHALL have a corresponding `"custom/<name>"` block in the waybar config.

#### Scenario: Config block exists for each script
- **WHEN** a script exists in `scripts/` and is used as a module
- **THEN** a `"custom/<name>"` block exists in the waybar config referencing that script

### Requirement: Module naming convention
Custom module names SHALL follow the pattern `custom/<descriptive-name>` (e.g., `custom/mpd`, `custom/is_in_playlist`).

#### Scenario: Naming is consistent
- **WHEN** a new custom module is added
- **THEN** its config key follows `custom/<kebab-case-name>` format

### Requirement: Long-lived modules use tail mode
Modules that continuously update SHALL use `"tail": true` in their config block and output one line per update to stdout.

#### Scenario: Tail module outputs updates
- **WHEN** a tail-mode module script prints a line to stdout
- **THEN** waybar updates the module display with that line

### Requirement: Adding a new module follows a documented pattern
Adding a new custom module SHALL require only: (1) creating a script in `data/scripts/`, (2) adding a `"custom/*"` block to the config, (3) adding the module name to a bar layout array.

#### Scenario: New module can be added in 3 steps
- **WHEN** a developer wants to add a new custom module
- **THEN** they create a script, add a config block, and add the module name to the bar layout — no other changes needed

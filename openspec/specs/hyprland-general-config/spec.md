## ADDED Requirements

### Requirement: cursor block uses correct key names

The `cursor` block in `general.lua` SHALL use only key names recognized by the installed Hyprland version.

#### Scenario: warp_on_change_workspace is correct

- **WHEN** Hyprland loads the `cursor` block from `general.lua`
- **THEN** the key `warp_on_change_workspace` SHALL be used instead of `warp_on_workspace_change`

#### Scenario: No unknown cursor keys

- **WHEN** `hyprctl reload` is executed
- **THEN** the Hyprland log SHALL NOT contain "unknown config key" errors for any `cursor.*` key

### Requirement: misc block uses correct key names

The `misc` block in `general.lua` SHALL use only key names recognized by the installed Hyprland version.

#### Scenario: disable_hyprland_logo is correct

- **WHEN** Hyprland loads the `misc` block from `general.lua`
- **THEN** the key `disable_hyprland_logo` SHALL be used instead of `disable_logo`

#### Scenario: disable_xdg_env_checks and enable_anr_dialog replace disable_xdg_anr

- **WHEN** Hyprland loads the `misc` block from `general.lua`
- **THEN** the key `disable_xdg_env_checks` SHALL be set to `true`
- **AND** the key `enable_anr_dialog` SHALL be set to `false`
- **AND** the key `disable_xdg_anr` SHALL NOT appear (it never existed as a valid key)

#### Scenario: on_focus_under_fullscreen replaces new_window_takes_over_fullscreen

- **WHEN** Hyprland loads the `misc` block from `general.lua`
- **THEN** the key `on_focus_under_fullscreen` SHALL be set to `2` instead of `new_window_takes_over_fullscreen`

#### Scenario: No unknown misc keys

- **WHEN** `hyprctl reload` is executed
- **THEN** the Hyprland log SHALL NOT contain "unknown config key" errors for any `misc.*` key

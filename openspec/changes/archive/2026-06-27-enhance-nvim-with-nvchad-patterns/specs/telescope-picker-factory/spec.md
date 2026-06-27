## ADDED Requirements

### Requirement: Telescope picker factory with layout presets
The system SHALL provide a `jasper.telescope` module with reusable layout presets and a picker factory function.

#### Scenario: Picker factory creates pickers with preset layout
- **WHEN** `jasper.telescope.picker("find_files", { preset = "horizontal" })` is called
- **THEN** a Telescope picker SHALL open with a horizontal layout preset (width: 0.8, height: 0.8)

#### Scenario: Vertical preset creates a centered tall picker
- **WHEN** `jasper.telescope.picker("live_grep", { preset = "vertical" })` is called
- **THEN** a Telescope picker SHALL open with a vertical layout preset (width: 0.6, height: 0.9)

#### Scenario: Tiny preset creates a small picker in the top-right
- **WHEN** `jasper.telescope.picker("buffers", { preset = "tiny" })` is called
- **THEN** a Telescope picker SHALL open with a tiny layout preset (width: 0.3, height: 0.3, anchor: TOP_RIGHT)

#### Scenario: Full preset uses maximum available space
- **WHEN** `jasper.telescope.picker("help_tags", { preset = "full" })` is called
- **THEN** a Telescope picker SHALL open with a full layout preset (width: 0.95, height: 0.95)

#### Scenario: Custom layout overrides preset
- **WHEN** `jasper.telescope.picker("find_files", { preset = "horizontal", layout_config = { width = 0.5 } })` is called
- **THEN** the layout SHALL use width 0.5 instead of the default for the preset

#### Scenario: Default preset is used when no preset is specified
- **WHEN** `jasper.telescope.picker("find_files")` is called
- **THEN** the default "horizontal" preset SHALL be applied

### Requirement: Convenience wrapper functions
The system SHALL provide convenience wrappers for common Telescope pickers.

#### Scenario: ff function opens find_files picker
- **WHEN** `jasper.telescope.ff()` is called
- **THEN** it SHALL call `jasper.telescope.picker("find_files", { preset = "horizontal" })`

#### Scenario: fg function opens live_grep picker
- **WHEN** `jasper.telescope.fg()` is called
- **THEN** it SHALL call `jasper.telescope.picker("live_grep", { preset = "vertical" })`

#### Scenario: fb function opens buffers picker
- **WHEN** `jasper.telescope.fb()` is called
- **THEN** it SHALL call `jasper.telescope.picker("buffers", { preset = "tiny" })`

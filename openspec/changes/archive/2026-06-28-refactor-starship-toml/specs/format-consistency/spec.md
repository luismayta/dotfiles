## ADDED Requirements

### Requirement: Uniform format string pattern
All modules SHALL use the standard format pattern `"[$symbol$version]($style) "` or `"[$output]($style) "` without leading pipes or extraneous separators.

#### Scenario: No pipe prefixes in format strings
- **WHEN** searching for formats with `\|` in format strings
- **THEN** the file SHALL contain zero matches

#### Scenario: Go module uses standard format
- **WHEN** inspecting the `[golang]` format
- **THEN** it SHALL be `"[$symbol $version]($style) "` (no `| Go` prefix)

### Requirement: Style values use a consistent color scheme
Color/style values SHALL use either named colors (bold cyan, bold green) or hex colors consistently, not mixed arbitrarily.

#### Scenario: Style values are validated
- **WHEN** inspecting style declarations
- **THEN** each SHALL follow `"bold <color>"` or `"fg:<color> bg:<color>"` pattern, not arbitrary formats

### Requirement: Nerd Font icons as default
All module symbols SHALL use Nerd Font icons where available, falling back to emoji only when no Nerd Font equivalent exists.

#### Scenario: No random emoji/icon mixing
- **WHEN** checking module symbols
- **THEN** each SHALL be a Nerd Font codepoint (e.g., ``, ``) or a documented standard emoji

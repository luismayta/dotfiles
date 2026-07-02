## ADDED Requirements

### Requirement: Configure custom Telescope presets
The system SHALL configure custom Telescope.nvim presets for file finding, live grep, and buffer switching that override LazyVim defaults.

#### Scenario: Custom file finder works
- **WHEN** user invokes `<leader>ff`
- **THEN** Telescope SHALL open with custom file finder configuration (hidden files, ignore patterns, etc.)

#### Scenario: Custom live grep works
- **WHEN** user invokes `<leader>fg`
- **THEN** Telescope SHALL open with custom live grep configuration (respect .gitignore, ripgrep args, etc.)

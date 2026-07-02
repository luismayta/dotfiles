## ADDED Requirements

### Requirement: Configure ccc.nvim
The system SHALL configure ccc.nvim for color picking and color code manipulation.

#### Scenario: Color picker is available
- **WHEN** user invokes the color picker on a color value
- **THEN** a color picker UI SHALL open for selecting/editing the color

### Requirement: Configure goto-preview.nvim
The system SHALL configure goto-preview.nvim for previewing definitions and references in a floating window.

#### Scenario: Preview definition in float
- **WHEN** user invokes goto-preview on a symbol
- **THEN** the definition SHALL be displayed in a floating window without leaving the current buffer

## ADDED Requirements

### Requirement: Sections grouped by category
The starship.toml SHALL organize modules into logical sections delimited by comment headers.

#### Scenario: Sections have clear headers
- **WHEN** reading the file
- **THEN** each section SHALL have a `## TITLE` comment header followed by a separator line `## ---`

#### Scenario: Section order is defined
- **WHEN** modules are listed
- **THEN** they MUST follow this order: Core → Shell → Git → Cloud → Languages → Tools → Environment → System → Custom

### Requirement: No duplicate module definitions
The file SHALL NOT contain duplicate `[module_name]` declarations.

#### Scenario: grep for duplicates returns empty
- **WHEN** running `grep '^\[' starship.toml | sort | uniq -d`
- **THEN** the output SHALL be empty

### Requirement: Comments describe module purpose
Every module SHALL have a preceding comment explaining its purpose when the module name is not self-explanatory.

#### Scenario: Obscure modules have comments
- **WHEN** a module like `[shell]` or `[character]` is declared
- **THEN** it MUST have a `#` comment above it describing its role

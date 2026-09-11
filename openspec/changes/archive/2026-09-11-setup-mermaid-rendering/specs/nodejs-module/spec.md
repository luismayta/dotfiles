## MODIFIED Requirements

### Requirement: NPM package manager
The module SHALL install npm packages defined in `NODEJS_PACKAGES` array via `bun install -g`. The array SHALL include `@mermaid-js/mermaid-cli` (mmdc) as a global package for mermaid diagram rendering.

#### Scenario: NPM packages install
- **WHEN** `nodejs::internal::packages::install` is called
- **THEN** all packages in `NODEJS_PACKAGES` SHALL be installed via `bun install -g`

#### Scenario: mmdc installed as global package
- **WHEN** `nodejs::internal::packages::install` is called
- **THEN** `@mermaid-js/mermaid-cli` SHALL be installed globally and `mmdc` SHALL be available in PATH
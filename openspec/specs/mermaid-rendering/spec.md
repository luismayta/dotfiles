## Purpose

Setup persistente y reproducible para el renderizado de diagramas mermaid en dotfiles: instalación de chrome-headless-shell en ubicación permanente, configuración de puppeteer-config.json, e integración de mmdc como paquete global del módulo nodejs.

### Requirement: chrome-headless-shell persistent install
The system SHALL install chrome-headless-shell in a persistent location (`~/.local/share/chrome-headless-shell`) using `bunx @puppeteer/browsers install chrome-headless-shell@stable --path`. The install SHALL be idempotent — if the binary already exists at the target path, the install SHALL be skipped.

#### Scenario: First-time install
- **WHEN** `~/.local/share/chrome-headless-shell` does not exist
- **THEN** the system SHALL execute `bunx @puppeteer/browsers install chrome-headless-shell@stable --path ~/.local/share/chrome-headless-shell` and the binary SHALL be available at that path

#### Scenario: Idempotent skip
- **WHEN** `~/.local/share/chrome-headless-shell` already exists and contains the binary
- **THEN** the install SHALL be skipped without error

### Requirement: puppeteer-config.json generation
The system SHALL create a `puppeteer-config.json` file with `executablePath` pointing to the persistent chrome-headless-shell binary. The config file location SHALL be resolvable via the `PUPPETEER_CONFIG_PATH` environment variable.

#### Scenario: Config file created
- **WHEN** chrome-headless-shell is installed successfully
- **THEN** a `puppeteer-config.json` SHALL exist with `{ "executablePath": "<path-to-chrome-headless-shell-binary>" }`

#### Scenario: Config path accessible via env var
- **WHEN** `PUPPETEER_CONFIG_PATH` is set
- **THEN** `mmdc` SHALL be able to locate the puppeteer config through this variable

### Requirement: mmdc as NODEJS_PACKAGES member
The system SHALL include `@mermaid-js/mermaid-cli` in the `NODEJS_PACKAGES` array in `zsh/modules/nodejs/config/base.zsh`, so it installs via the existing `bun install -g` mechanism (`nodejs::internal::packages::install`).

#### Scenario: mmdc installed via bun
- **WHEN** `nodejs::internal::packages::install` is called
- **THEN** `@mermaid-js/mermaid-cli` SHALL be installed globally via `bun install -g`

#### Scenario: mmdc available in PATH
- **WHEN** the nodejs module has loaded and packages are installed
- **THEN** `mmdc` command SHALL be available in PATH

### Requirement: mmdc renders diagrams without errors
The system SHALL verify that `mmdc` can render a mermaid diagram to a target format (e.g., PNG or SVG) using the persistent chrome-headless-shell as its browser.

#### Scenario: Successful render
- **WHEN** a valid mermaid diagram file is provided to `mmdc`
- **THEN** the output file SHALL be generated without errors using the persistent chrome-headless-shell binary

### Requirement: Documentation in dotfiles
The `zsh/modules/nodejs/README.yaml` SHALL document the mermaid rendering setup, including the `chrome-headless-shell` installation location and the `puppeteer-config.json` configuration.

#### Scenario: README reflects setup
- **WHEN** `task readme` is run for the nodejs module
- **THEN** the generated README.md SHALL include documentation about mermaid rendering capabilities
## ADDED Requirements

### Requirement: Install URL convention defined
The system SHALL define a project-wide convention for declaring tool installation URLs as exported variables in module config files.

#### Scenario: Convention is documented
- **WHEN** inspecting any module's `config/base.zsh`
- **THEN** install URLs SHALL follow the pattern `<MODULE>_INSTALL_URL_<TOOL>`, where `<MODULE>` is the uppercase module name and `<TOOL>` is the uppercase tool identifier

#### Scenario: Variables are exported
- **WHEN** inspecting a module's `config/base.zsh`
- **THEN** all `*_INSTALL_URL_*` variables SHALL be declared with the `export` keyword

### Requirement: URL variables consumed by internal files
The system SHALL reference install URL variables from `config/` in `internal/` implementation files, rather than embedding hardcoded URLs.

#### Scenario: Internal file uses variable
- **WHEN** inspecting a module's `internal/base.zsh`
- **THEN** any install URL used SHALL reference the corresponding `*_INSTALL_URL_*` variable, NOT a hardcoded URL string

#### Scenario: No behavior change
- **WHEN** the module's install function executes
- **THEN** the URL used SHALL be identical to the pre-migration hardcoded URL

### Requirement: OS-specific overrides supported
The system SHALL support architecture or OS-specific URL overrides via `config/osx.zsh` or `config/linux.zsh`.

#### Scenario: OS override takes precedence
- **WHEN** an OS-specific config file defines a `*_INSTALL_URL_*` variable with the same name as `config/base.zsh`
- **THEN** the OS-specific value SHALL be used at runtime on that platform
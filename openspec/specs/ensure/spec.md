## ADDED Requirements

### Requirement: core::ensure function exists
The system SHALL provide a `core::ensure` function in `zsh/core/pkg/base.zsh` that conditionally installs a tool if it is not present.

#### Scenario: core::ensure with missing tool
- **WHEN** `core::ensure <tool>` is called and `<tool>` is not installed
- **THEN** the function SHALL call `core::exists <tool>`, detect it is missing, and call `core::install <tool>`

#### Scenario: core::ensure with existing tool
- **WHEN** `core::ensure <tool>` is called and `<tool>` is already installed
- **THEN** the function SHALL call `core::exists <tool>`, detect it is present, and NOT call `core::install <tool>`

### Requirement: Modules use core::ensure instead of manual guard
Modules that currently use the `if ! core::exists <tool>; then core::install <tool>; fi` pattern SHALL be updated to use `core::ensure <tool>` instead.

#### Scenario: Module guard replaced
- **WHEN** a module previously used `if ! core::exists <tool>; then core::install <tool>; fi`
- **THEN** the replacement SHALL be `core::ensure <tool>`

#### Scenario: tools-k9s load guard
- **WHEN** zsh/modules/devops/devops/pkg/k9s.zsh loads
- **THEN** it SHALL use `core::ensure k9s` instead of the manual guard

#### Scenario: tools-kubectl load guard
- **WHEN** zsh/modules/devops/devops/pkg/kubectl.zsh loads
- **THEN** it SHALL use `core::ensure kubectl` instead of the manual guard

#### Scenario: tools-helm load guard
- **WHEN** zsh/modules/devops/devops/pkg/helm.zsh loads
- **THEN** it SHALL use `core::ensure helm` instead of the manual guard

#### Scenario: fzf load guard
- **WHEN** zsh/modules/fzf/fzf/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure fzf` instead of the manual guard

#### Scenario: bat load guard
- **WHEN** zsh/modules/bat/bat/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure bat` instead of the manual guard

#### Scenario: ripgrep load guard
- **WHEN** zsh/modules/ripgrep/ripgrep/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure ripgrep` instead of the manual guard

#### Scenario: ghq load guard
- **WHEN** zsh/modules/ghq/ghq/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure ghq` instead of the manual guard

#### Scenario: pazi load guard
- **WHEN** zsh/modules/pazi/pazi/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure pazi` instead of the manual guard

#### Scenario: scmbreeze load guard
- **WHEN** zsh/modules/scmbreeze/scmbreeze/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure scmbreeze` instead of the manual guard

#### Scenario: notify load guard
- **WHEN** zsh/modules/notify/notify/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure notify` instead of the manual guard

#### Scenario: starship load guard
- **WHEN** zsh/modules/starship/starship/pkg/base.zsh loads
- **THEN** it SHALL use `core::ensure starship` instead of the manual guard
## ADDED Requirements

### Requirement: Module template env var
The root `Taskfile.yml` SHALL define a `README_MODULE_TEMPLATE` environment variable pointing to the shared module template.

#### Scenario: env var is defined
- **WHEN** inspecting the `env` block of the root `Taskfile.yml`
- **THEN** `README_MODULE_TEMPLATE` SHALL be present with value pointing to `provision/templates/README.module.tpl.md`

### Requirement: Per-module README.yaml
The pilot module SHALL have a `README.yaml` at its root directory with module metadata.

#### Scenario: module README.yaml exists
- **WHEN** inspecting `zsh/modules/git/README.yaml`
- **THEN** the file SHALL exist
- **AND** it SHALL contain a `name` field

### Requirement: Per-module readme task
The pilot module SHALL have a `readme` task in its `Taskfile.yml` that generates `README.md` using the shared template and its own `README.yaml`.

#### Scenario: readme task exists
- **WHEN** running `task readme` inside `zsh/modules/git/`
- **THEN** a `zsh/modules/git/README.md` file SHALL be generated

#### Scenario: readme task uses shared template
- **WHEN** inspecting the readme task definition
- **THEN** it SHALL reference `{{.README_MODULE_TEMPLATE}}` and the module's own `README.yaml` as datasource

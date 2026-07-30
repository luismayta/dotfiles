## ADDED Requirements

### Requirement: Shared module README template
The repository SHALL contain a gomplate template at `provision/templates/README.module.tpl.md` for generating per-module README.md files.

#### Scenario: template file exists
- **WHEN** inspecting `provision/templates/README.module.tpl.md`
- **THEN** the file SHALL exist

#### Scenario: template renders module name
- **WHEN** the template is rendered with a module README.yaml datasource
- **THEN** the output SHALL contain the module name from the datasource

#### Scenario: template includes description
- **WHEN** the datasource has a `description` field
- **THEN** the rendered output SHALL include the description content

### Requirement: Template supports module-specific sections
The template SHALL support conditional sections for features, requirements, usage, examples, and includes.

#### Scenario: features section conditionally rendered
- **WHEN** the datasource contains a `features` list
- **THEN** the rendered output SHALL include a "## Features" section with the list items

#### Scenario: usage section included from file
- **WHEN** the datasource specifies a `usages` path
- **THEN** the rendered output SHALL include the content of that file

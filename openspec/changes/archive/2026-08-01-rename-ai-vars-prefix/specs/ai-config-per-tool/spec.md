## MODIFIED Requirements

### Requirement: AI tool config separated per tool

The AI module config layer SHALL provide one dedicated config file per AI tool under `zsh/modules/ai/config/`, named `config/<tool>.zsh`, with all tool variables prefixed `ZSH_AI_<TOOL>_`.

#### Scenario: Every registered tool has a config file

- **WHEN** the AI module loads
- **THEN** every tool listed in `ZSH_AI_TOOLS` SHALL have a corresponding `config/<tool>.zsh` file with its own variables

#### Scenario: Aggregated tool config removed

- **WHEN** the AI module config layer is inspected
- **THEN** no tool SHALL have its variables defined in a shared catch-all file (`tools.zsh` or similar)

### Requirement: Install URLs colocated with their tool

The installation URL of a tool SHALL be defined in that tool's own config file, never in `config/base.zsh`.

#### Scenario: URL defined in tool config

- **WHEN** a tool has an install URL (e.g., `ZSH_AI_INSTALL_URL_OPENCODE`)
- **THEN** the URL SHALL be exported from `config/<tool>.zsh` and SHALL NOT appear in `config/base.zsh`

#### Scenario: Ollama models grouped with ollama config

- **WHEN** the ollama configuration is inspected
- **THEN** `ZSH_AI_OLLAMA_MODELS` and `ZSH_AI_OLLAMA_MODELS_PATH` SHALL both be defined in `config/ollama.zsh`

### Requirement: Base config restricted to registry and cross-cutting concerns

`config/base.zsh` SHALL contain only cross-cutting concerns (enable flag, architecture, package name) and the `ZSH_AI_TOOLS` registry.

#### Scenario: Base contains no tool variables

- **WHEN** `config/base.zsh` is inspected
- **THEN** it SHALL NOT export any `ZSH_AI_INSTALL_URL_*` or `ZSH_AI_<TOOL>_*` variable other than the `ZSH_AI_TOOLS` registry

### Requirement: Platform config without dead duplication

Platform config files (`config/linux.zsh`, `config/osx.zsh`) SHALL be the only place defining platform-specific values, and `config/base.zsh` SHALL NOT define a generic value that is always overridden by them.

#### Scenario: Shimmy URL defined once

- **WHEN** the module loads on a platform
- **THEN** `ZSH_AI_INSTALL_URL_SHIMMY` SHALL resolve from the platform config file and SHALL NOT be overridden from a duplicate definition in `config/base.zsh`

### Requirement: Consistent naming per AI tool

The AI module SHALL recognize `codegraph` and `graphify` as two distinct code-intelligence tools, each with internally consistent naming: matching config file, variable prefix, registry entry, and function family.

- `codegraph`: binary / MCP server, installed via curl from the codegraph installer URL.
- `graphify`: knowledge-graph skill, installed via `uv tool install` (package `graphifyy[all]`).

#### Scenario: Codegraph naming consistent

- **WHEN** the codegraph configuration is inspected
- **THEN** `config/codegraph.zsh`, its `ZSH_AI_CODEGRAPH_*` variables, the `codegraph` entry in `ZSH_AI_TOOLS`, and the `ai::internal::codegraph::*` functions SHALL all refer to the same tool

#### Scenario: Graphify naming consistent

- **WHEN** the graphify configuration is inspected
- **THEN** `config/graphify.zsh`, its `ZSH_AI_GRAPHIFY_*` variables, and the `ai::graphify::*` / `ai::internal::graphify::*` functions SHALL all refer to the same tool

#### Scenario: Both tools registered

- **WHEN** the `ZSH_AI_TOOLS` registry is inspected
- **THEN** it SHALL include both `codegraph` and `graphify`, and each SHALL have a config file and an install function

#### Scenario: Graphify install dispatch reachable

- **WHEN** `ai::internal::packages::install` iterates `ZSH_AI_TOOLS`
- **THEN** the `graphify` case SHALL dispatch to `ai::internal::graphify::install` (no dead dispatch branch)

## REMOVED Requirements

### Requirement: Variable names stable across refactor

**Reason**: La garantía de no renombramiento fue una restricción temporal del refactor de separación de config (`refactor-ai-config-per-tool`). El change `rename-ai-vars-prefix` estandariza deliberadamente el prefijo de TODAS las variables del módulo AI de `AI_` a `ZSH_AI_`.

**Migration**: Usar el nuevo prefijo `ZSH_AI_<TOOL>_` para todas las variables del módulo AI (paths, config paths, install URLs, registry, models). Las funciones `ai::*` no se ven afectadas.

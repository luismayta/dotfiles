# ai-rea Specification

## Purpose
Integrate REA (Reverse Engineer Anything) into the `ai` module as a PATH-only, version-pinned CLI managed through dedicated `ZSH_AI_REA_*` configuration, with a Node.js engine gate, an idempotent install lifecycle, public wrappers, and agent-side MCP registration.

## Requirements

### Requirement: Dedicated tool configuration

The module SHALL provide `config/rea.zsh` defining `ZSH_AI_REA_*` settings for the pinned package spec (`rea-agents@6.7.0`), the install method, the install URL, the binary directory, and the skill directory, and SHALL register `rea` in `ZSH_AI_TOOLS`.

#### Scenario: Config file is sourced

- **WHEN** the `ai` module config layer loads
- **THEN** `config/rea.zsh` is sourced and defines the `ZSH_AI_REA_*` variables

#### Scenario: Tool registered in the tools array

- **WHEN** `ZSH_AI_TOOLS` is inspected after the config layer loads
- **THEN** it SHALL contain the `rea` entry

#### Scenario: Modern variable naming

- **WHEN** the REA config and implementation files are inspected
- **THEN** every variable SHALL use the `ZSH_AI_REA_` prefix and none SHALL use the legacy `ZSH_AI_<SUFFIX>_REA` ordering

### Requirement: Load guard prepends the binary directory

`ai::internal::rea::load` SHALL prepend `${ZSH_AI_REA_BIN_PATH}` to `PATH` when a `rea` file exists in that directory, and SHALL return successfully without touching `PATH` or printing errors otherwise.

#### Scenario: Binary present but not yet on PATH

- **WHEN** `${ZSH_AI_REA_BIN_PATH}/rea` exists and `rea` is not resolvable on `PATH`
- **THEN** the load function prepends the binary directory so `rea` becomes resolvable

#### Scenario: Tool not installed

- **WHEN** the module loads on a machine without `rea`
- **THEN** the load function returns successfully, prints nothing, and leaves `PATH` unchanged

### Requirement: Node.js runtime gate

The install path SHALL verify that `node` is available and that its version satisfies `^22.19.0`, `^24.11.0`, or `>=26.0.0`, rejecting 23.x, 25.x, and any version below 22.19.0 before invoking an installer.

#### Scenario: Supported runtime

- **WHEN** `node -v` reports `v22.19.0`, `v24.11.0`, `v26.0.0`, or a later release in one of those lines
- **THEN** the gate passes and installation proceeds

#### Scenario: Unsupported major

- **WHEN** `node -v` reports a 23.x or 25.x version
- **THEN** the gate fails, emits an error through `message_error`, and SHALL NOT run an installer

#### Scenario: Below the minimum supported release

- **WHEN** `node -v` reports `v22.18.0` or `v24.10.0`
- **THEN** the gate fails, emits an error through `message_error`, and SHALL NOT run an installer

#### Scenario: Node missing

- **WHEN** no `node` executable is available
- **THEN** the install aborts with an error that names Node.js as the missing prerequisite

### Requirement: Install is idempotent

`ai::internal::rea::install` SHALL return early with an informational message when `rea` already resolves on `PATH`, and MUST NOT reinstall or overwrite the existing installation.

#### Scenario: Install run twice

- **WHEN** the install function is invoked while `rea` is already available
- **THEN** it reports that REA is already installed and performs no installation

### Requirement: Install supports npm, bun, and curl methods

The install function SHALL select its method from configuration — npm global, bun global, or the upstream curl installer — SHALL verify the prerequisites of the selected method, and SHALL report success and failure through the module's message helpers.

#### Scenario: npm method

- **WHEN** the configured method is npm and npm is available with a supported Node.js runtime
- **THEN** the function installs the pinned `rea-agents` package globally

#### Scenario: npm global prefix is not writable

- **WHEN** the configured method is npm and the npm global prefix is not writable (for example an immutable store path)
- **THEN** the function warns which prefix is unwritable and how to override the method, falls back to the upstream curl installer for that run, and follows the curl method's prerequisite and failure handling

#### Scenario: curl method on Linux

- **WHEN** the configured method is curl and curl is available
- **THEN** the function runs the upstream installer non-interactively (the installer is invoked with `--no-setup`, so the interactive setup wizard stays owned by `ai::rea::setup`) and afterwards makes `rea` resolvable from `${ZSH_AI_REA_BIN_PATH}`

#### Scenario: Method prerequisite missing

- **WHEN** the selected method's prerequisite (npm, bun, or curl) is unavailable
- **THEN** the function emits an error through `message_error`, returns a non-zero status, and does not invoke an installer

#### Scenario: Installer fails

- **WHEN** the selected installer exits non-zero
- **THEN** the function emits an error through `message_error` and returns a non-zero status

### Requirement: An unreachable binary is reported as an incomplete install

After the installer exits successfully, the install function SHALL verify that `rea` resolves, and SHALL report an unreachable binary as an incomplete install instead of a successful one.

#### Scenario: Installed binary is not reachable

- **WHEN** the installer exits with a zero status but `rea` does not resolve afterwards
- **THEN** the function warns naming the directory the selected method installed the binary into, tells the user to add that directory to `PATH` or run `ai::rea::doctor`, and returns a non-zero status without reporting success

### Requirement: Skill management delegated to rea setup

The module SHALL delegate installation and refresh of the `reverse-engineer-anything` skill to `rea setup`, SHALL document that decision in the tool's public setup path, and MUST NOT implement a separate skill sync.

#### Scenario: Setup installs the skill

- **WHEN** a user runs `ai::rea::setup`
- **THEN** the module invokes `rea setup`, which installs the skill into `${ZSH_AI_REA_SKILLS_DIR}` when selected without a client

#### Scenario: No custom skill sync exists

- **WHEN** the module's public and internal function families are inspected
- **THEN** no REA-specific skill sync function SHALL exist and the delegated behavior SHALL be documented

### Requirement: Agent MCP surface documented after install

After a successful install, the module SHALL print guidance that REA exposes an MCP server with its analysis tools and six guided prompts (`investigate_feature`, `compare_application_versions`, `verify_reconstruction`, `trace_crash`, `audit_residual_unknowns`, `prepare_bounded_process_capture`) available to the agent, and SHALL point to `rea doctor` for diagnostics.

#### Scenario: Guidance printed on first install

- **WHEN** the first install completes successfully
- **THEN** the output names the MCP servers' tool and prompt surface, the six prompts, and the `rea doctor` verification step

### Requirement: Agent MCP registration is version pinned

The agent configuration template SHALL register the REA MCP server as a local stdio server invoking the pinned package version `rea-agents@6.7.0`, and MUST NOT use a floating `@latest` tag for persistent registration.

#### Scenario: OpenCode template entry

- **WHEN** the OpenCode config template is inspected
- **THEN** it contains an `mcp.rea` entry with type `local`, enabled, and command `npx -y rea-agents@6.7.0 mcp`

#### Scenario: Sync propagates the entry

- **WHEN** the user runs the module's OpenCode sync path
- **THEN** the `mcp.rea` entry reaches the generated agent configuration

### Requirement: Public lifecycle wrappers

The module SHALL expose `ai::rea::install`, `ai::rea::doctor`, `ai::rea::setup`, and `ai::rea::post_install`, each delegating to the corresponding `ai::internal::rea::*` implementation, with `ai::rea::setup` also participating in the module-wide `ai::setup` aggregate.

#### Scenario: Wrapper delegates

- **WHEN** a user calls `ai::rea::doctor`
- **THEN** the call is delegated to the internal implementation with identical output

#### Scenario: Aggregate setup includes REA

- **WHEN** a user runs `ai::setup`
- **THEN** `ai::rea::setup` runs as part of the aggregate and a failure is counted in its failure total

### Requirement: Explicit install dispatch

`ai::internal::packages::install` SHALL route the `rea` entry of `ZSH_AI_TOOLS` to the REA install implementation and MUST NOT fall through to the generic `core::install` fallback.

#### Scenario: Registry-driven install

- **WHEN** the batch installer iterates `ZSH_AI_TOOLS` and reaches `rea`
- **THEN** it dispatches to the REA install function instead of `core::install`

### Requirement: User output via message functions

Every user-facing message produced by REA lifecycle functions SHALL use `message_info`, `message_success`, `message_warning`, or `message_error`; `echo` MUST NOT be used, and every error path SHALL return a non-zero status explicitly.

#### Scenario: Error path uses message_error

- **WHEN** a prerequisite check fails
- **THEN** the message is emitted through `message_error` and the function returns non-zero

#### Scenario: Success path uses message_success

- **WHEN** install or setup completes
- **THEN** the completion message is emitted through `message_success`

### Requirement: Configuration hygiene and scope guard

The REA files SHALL avoid `eval` in the config layer, SHALL expand only `${HOME}` or `${ZSH_AI_PATH}` instead of hard-coded absolute paths, and the tool's implementation MUST NOT modify `README.md`, `README.yaml`, or create a `data/rea/` directory.

#### Scenario: No eval or absolute paths

- **WHEN** the three REA module files are inspected
- **THEN** they contain no `eval` call and no hard-coded absolute home or tool path

#### Scenario: Repository scope respected

- **WHEN** the change is implemented and `git status --porcelain` is checked
- **THEN** no change to `README.md` or `README.yaml` appears and no `data/rea/` directory exists

# ai-freellmapi

## Purpose

The `ai` module manages freellmapi — an OpenAI-compatible LLM router — as a local Docker Compose service rather than a binary: dedicated config, an artifact-based guard, an install/upgrade/status lifecycle under the `ai::internal::freellmapi::*` namespace with public `ai::freellmapi::*` wrappers, registration at the module's four registration points, and post-installation guidance.

## ADDED Requirements

### Requirement: Dedicated tool configuration

The module SHALL provide `config/freellmapi.zsh` defining freellmapi settings with the `ZSH_AI_FREELLMAPI_` prefix (`ZSH_AI_FREELLMAPI_PACKAGE_NAME`, `ZSH_AI_FREELLMAPI_INSTALL_URL`, `ZSH_AI_FREELLMAPI_DIR`, `ZSH_AI_FREELLMAPI_PORT`, `ZSH_AI_FREELLMAPI_HOST_BIND`, `ZSH_AI_FREELLMAPI_IMAGE`, `ZSH_AI_FREELLMAPI_HEALTH_URL`), and SHALL register `freellmapi` in `ZSH_AI_TOOLS`.

#### Scenario: Config file is sourced

- **WHEN** the `ai` module config layer loads
- **THEN** `config/freellmapi.zsh` is sourced and defines the `ZSH_AI_FREELLMAPI_*` variables

#### Scenario: Tool registered in the tools array

- **WHEN** `ZSH_AI_TOOLS` is inspected after the config layer loads
- **THEN** it SHALL contain the `freellmapi` entry

### Requirement: Load is a PATH-neutral no-op

`ai::internal::freellmapi::load` SHALL NOT modify `PATH`, SHALL NOT create any artifact under `data/`, and SHALL complete successfully even when `${ZSH_AI_FREELLMAPI_DIR}` does not exist yet, because freellmapi ships no binary.

#### Scenario: Load before install

- **WHEN** the internal layer loads and `${ZSH_AI_FREELLMAPI_DIR}` does not exist
- **THEN** `ai::internal::freellmapi::load` returns successfully, prints no error, and leaves `PATH` unchanged

#### Scenario: Load after install

- **WHEN** the service is already deployed and the module loads
- **THEN** `ai::internal::freellmapi::load` still does not prepend anything to `PATH`

### Requirement: Artifact-based installed guard

The installed guard SHALL consider freellmapi present when `${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml` exists and/or the Docker daemon responds to `docker info`, and MUST NOT rely on `core::exists freellmapi`, which only caches positives for PATH binaries.

#### Scenario: Compose file on disk

- **WHEN** `${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml` exists
- **THEN** the guard SHALL report freellmapi as already deployed and skip installation

#### Scenario: No binary on PATH

- **WHEN** no `freellmapi` executable exists on `PATH`
- **THEN** the guard SHALL still detect an existing deployment from the on-disk compose file

### Requirement: Install validates prerequisites

`ai::internal::freellmapi::install` SHALL verify that the Docker daemon is running, that Compose is available (`docker compose` or `docker-compose`), and that `curl` is present; if any prerequisite is missing it SHALL emit `message_error` and return a non-zero status without running the installer.

#### Scenario: Docker daemon unreachable

- **WHEN** the user runs the install function and `docker info` fails
- **THEN** the function SHALL emit an error via `message_error` and SHALL NOT execute the official installer

#### Scenario: Compose unavailable

- **WHEN** neither `docker compose version` nor `docker-compose --version` succeeds
- **THEN** the function SHALL abort with an error message before invoking the installer

### Requirement: Install deploys the official service

When prerequisites pass, the install function SHALL run the official freellmapi installer (fetched via `curl` from `ZSH_AI_FREELLMAPI_INSTALL_URL`), which deploys the pinned Docker Compose service with its `.env`, healthcheck, and named volume, and SHALL report completion with `message_success`.

#### Scenario: Successful first install

- **WHEN** prerequisites are satisfied and the service is not yet deployed
- **THEN** the official installer runs to completion and the function reports success via `message_success`

### Requirement: Install is idempotent

A second invocation of the install function against an already deployed service SHALL detect the existing deployment via the artifact guard and SHALL NOT re-deploy or overwrite the existing `.env` and `ENCRYPTION_KEY`.

#### Scenario: Install run twice

- **WHEN** the install function is invoked while `${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml` already exists
- **THEN** it SHALL skip deployment, preserve the existing `.env`, and report that the service is already deployed

### Requirement: Upgrade preserves the encryption key

`ai::internal::freellmapi::upgrade` SHALL re-run the official installer to refresh the service and SHALL preserve the existing `.env` file and its `ENCRYPTION_KEY` unchanged.

#### Scenario: Upgrade of a deployed service

- **WHEN** the user runs the upgrade function on an existing installation
- **THEN** the `.env` file and `ENCRYPTION_KEY` SHALL remain byte-identical after the upgrade completes

### Requirement: Status reports service state

`ai::internal::freellmapi::status` SHALL report the service state — from the Compose state and/or the health endpoint `ZSH_AI_FREELLMAPI_HEALTH_URL` — and SHALL distinguish a running, healthy service from a stopped or unreachable one.

#### Scenario: Service up

- **WHEN** the user runs the status function and the health endpoint responds successfully
- **THEN** the function SHALL report the service as running

#### Scenario: Service down

- **WHEN** the user runs the status function while the service is stopped or the compose file is absent
- **THEN** the function SHALL report the service as not running and suggest the install function

### Requirement: Public lifecycle wrappers

The module SHALL expose public functions `ai::freellmapi::install`, `ai::freellmapi::upgrade`, and `ai::freellmapi::status`, each delegating to the corresponding `ai::internal::freellmapi::*` implementation.

#### Scenario: Public wrapper delegates

- **WHEN** a user calls `ai::freellmapi::status`
- **THEN** the call SHALL be delegated to `ai::internal::freellmapi::status` and produce the same output

### Requirement: Explicit install dispatch

`ai::internal::packages::install` SHALL route the `freellmapi` entry of `ZSH_AI_TOOLS` to the freellmapi install implementation, and MUST NOT fall through to the generic `core::install` fallback.

#### Scenario: Registry-driven install

- **WHEN** `ai::internal::packages::install` iterates `ZSH_AI_TOOLS` and reaches `freellmapi`
- **THEN** it SHALL dispatch to the freellmapi install function instead of `core::install`

### Requirement: User output via message functions

Every user-facing message produced by freellmapi lifecycle functions SHALL use `message_info`, `message_success`, `message_warning`, or `message_error`; `echo` MUST NOT be used.

#### Scenario: Error path uses message_error

- **WHEN** an install prerequisite check fails
- **THEN** the message SHALL be emitted through `message_error`, not `echo`

#### Scenario: Success path uses message_success

- **WHEN** install or upgrade completes
- **THEN** the completion message SHALL be emitted through `message_success`

### Requirement: Post-installation guidance

After a successful install, the module SHALL print next-step guidance: the dashboard URL `http://${ZSH_AI_FREELLMAPI_HOST_BIND}:${ZSH_AI_FREELLMAPI_PORT}`, adding provider keys, pointing clients at `/v1` (OpenAI-compatible) and `/v1/messages` (Anthropic), and a warning that losing the `ENCRYPTION_KEY` forces re-entering all provider keys.

#### Scenario: Guidance printed on first install

- **WHEN** the first install completes successfully
- **THEN** the output SHALL include the dashboard URL, the provider-key step, the `/v1` and `/v1/messages` endpoints, and the `ENCRYPTION_KEY` loss warning

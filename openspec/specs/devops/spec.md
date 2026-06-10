# devops Specification

## Purpose
TBD - created by archiving change migrate-zsh-modules. Update Purpose after archive.
## Requirements
### Requirement: Module provides DevOps tooling aliases and helpers
The devops module SHALL provide ZSH aliases and helper functions for common DevOps tooling, including platform-specific configuration for Linux and macOS.

#### Scenario: DevOps aliases available
- **WHEN** the module is loaded
- **THEN** the user can invoke DevOps-related aliases defined in `pkg/` and `internal/`

#### Scenario: Platform-specific tooling paths
- **WHEN** the system is macOS
- **THEN** macOS-specific DevOps paths from `pkg/osx.zsh` and `internal/osx.zsh` are available
- **WHEN** the system is Linux
- **THEN** Linux-specific DevOps paths from `pkg/linux.zsh` and `internal/linux.zsh` are available

### Requirement: Module follows existing dotfiles convention
The devops module SHALL be self-contained within `zsh/modules/devops/` with `plugin.zsh` as the entry point and `config/`, `internal/`, `pkg/` subdirectories.

#### Scenario: Entry point exists
- **WHEN** the module directory is inspected
- **THEN** `zsh/modules/devops/plugin.zsh` exists and is executable

#### Scenario: Subdirectory structure is complete
- **WHEN** the module files are enumerated
- **THEN** `config/`, `internal/`, and `pkg/` subdirectories contain the expected platform-specific files

## ADDED Requirements

### Requirement: Docker-based AWS CLI

The devops module SHALL provide `awscli()` that runs the AWS CLI inside a Docker container.

#### Scenario: awscli runs Docker container
- **WHEN** `awscli s3 ls` is called
- **THEN** Docker SHALL run `nikovirtala/awscli:latest` with current directory mounted at `/home/nikovirtala`, `~/.aws` mounted for credentials, and environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` passed through

### Requirement: Docker-based AWS Shell

The devops module SHALL provide `aws-shell()` that runs the AWS Shell inside a Docker container with the same mount and env configuration.

#### Scenario: aws-shell runs with same bindings as awscli
- **WHEN** `aws-shell` is called
- **THEN** Docker SHALL run `nikovirtala/aws-shell:latest` with the same volume mounts and environment variables as `awscli`

### Requirement: Docker-based YouTube-DL

The devops module SHALL provide `ytdl()` and `ytd-mp3()` functions that run youtube-dl inside a Docker container.

#### Scenario: ytdl downloads video
- **WHEN** `ytdl https://youtube.com/watch?v=abc` is called
- **THEN** Docker SHALL run `hadenlabs/youtube-dl` with `${PWD}:/data` and the URL as argument

#### Scenario: ytd-mp3 extracts audio
- **WHEN** `ytd-mp3 https://youtube.com/watch?v=abc` is called
- **THEN** Docker SHALL run `hadenlabs/youtube-dl` with `--extract-audio --audio-format mp3`

### Requirement: Docker-based nyan cat

The devops module SHALL provide `nyancat()` that runs the nyan cat animation in Docker.

#### Scenario: nyancat runs animation
- **WHEN** `nyancat` is called
- **THEN** Docker SHALL run `supertest2014/nyan` interactively

### Requirement: Docker-based Komiser dashboard

The devops module SHALL provide `komiser()` that runs the Komiser AWS dashboard in Docker.

#### Scenario: komiser starts dashboard on port 3000
- **WHEN** `komiser` is called
- **THEN** Docker SHALL run `mlabouardy/komiser:2.4.0` in detached mode on port 3000 with AWS environment variables
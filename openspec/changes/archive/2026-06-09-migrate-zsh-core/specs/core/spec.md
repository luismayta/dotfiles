## ADDED Requirements

### Requirement: Core module loads on shell start
The `zsh/modules/core/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with core functions available
- **WHEN** a shell starts
- **THEN** all `core::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_CORE_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `core/plugin.zsh` is sourced a second time
- **THEN** it SHALL return immediately without re-executing

### Requirement: Environment variables
The module SHALL export `ANDROID_HOME`, `ANDROID_PLATFORM_VERSION`, `ANDROID_SDK_VERSION`, `CORE_PROJECTS_BACKUP_PATH`, and `CORE_MESSAGE_*` variables.

#### Scenario: Env vars set after module loads
- **WHEN** the module is sourced
- **THEN** `ANDROID_HOME`, `CORE_PROJECTS_BACKUP_PATH`, and `CORE_MESSAGE_*` SHALL be exported

### Requirement: Package auto-install
The module SHALL provide `core::install` (brew-based) and `core::cargo::install` functions.

#### Scenario: brew install succeeds
- **WHEN** `core::install <formula>` is called and brew is available
- **THEN** it SHALL run `brew install <formula>`

### Requirement: Messaging functions
The module SHALL provide `core::message::info`, `core::message::error`, `core::message::warning`, and `core::message::success` with colored output.

#### Scenario: Info message prints
- **WHEN** `core::message::info "hello"` is called
- **THEN** it SHALL print a green `[INFO]: hello` message

### Requirement: FZF helper functions
The module SHALL provide fuzzy-finder helper functions including `fkill`, `fa`, `fcs`, `fenv`, `falias`, `fo`, `fgb`, `ftm`, `ftmk`, `fgr`, `fag`, `agr`, `pubkey`, `ip`, `localip`, `net`, and `download`.

#### Scenario: fkill kills a process
- **WHEN** user runs `fkill`
- **THEN** it SHALL display a fuzzy list of running processes and kill the selected one

#### Scenario: ip returns public IP
- **WHEN** user runs `ip`
- **THEN** it SHALL return the public IP address via OpenDNS

### Requirement: Docker CLI wrappers
The module SHALL provide Docker-based CLI wrappers `awscli`, `aws-shell`, `nyancat`, `ytd-mp3`, `ytdl`, `youtube-dl`, and `komiser`.

#### Scenario: awscli runs in Docker
- **WHEN** user runs `awscli <args>`
- **THEN** it SHALL run AWS CLI in a Docker container with local AWS credentials

### Requirement: eza ls replacement
The module SHALL provide eza-based aliases `ls`, `ll`, and `lsa` with icons, with auto-install via cargo.

#### Scenario: eza aliases loaded
- **WHEN** eza is installed
- **THEN** `ls`, `ll`, and `lsa` SHALL point to eza with icons

### Requirement: Linux clipboard helpers
On Linux, the module SHALL provide `pbcopy`, `pbpaste`, and `open` functions using xclip/xsel and xdg-open.

#### Scenario: pbcopy uses xclip on Linux
- **WHEN** user runs `pbcopy` on Linux
- **THEN** it SHALL copy stdin to clipboard via xclip or xsel

### Requirement: Git remote URL parser
The module SHALL provide `core::git::get_module_path` to parse git remote URLs into host/path format.

#### Scenario: SSH remote URL parsed
- **WHEN** `core::git::get_module_path` is called in a repo with SSH remote
- **THEN** it SHALL output `host/org/repo`

### Requirement: Project backup function
The module SHALL provide `core::backup::snapshot` to rsync the current git project to `$CORE_PROJECTS_BACKUP_PATH`.

#### Scenario: snapshot backs up project
- **WHEN** user runs `core::backup::snapshot` in a git repository
- **THEN** it SHALL rsync the project to `$CORE_PROJECTS_BACKUP_PATH/<remote>/<path>/<branch>`

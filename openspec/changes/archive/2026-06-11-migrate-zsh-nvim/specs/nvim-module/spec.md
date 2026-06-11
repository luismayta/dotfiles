## ADDED Requirements

### Requirement: Neovim auto-install

The module SHALL ensure `nvim` is installed via `core::install nvim` if not already present in the system. It SHALL also ensure `rsync` is installed.

#### Scenario: nvim is already installed
- **WHEN** the module loads and `nvim` exists in PATH
- **THEN** the module SHALL skip installation

#### Scenario: nvim is not installed
- **WHEN** the module loads and `nvim` is not found in PATH
- **THEN** the module SHALL call `core::install nvim` to install it

### Requirement: nvimrc configuration management

The module SHALL clone the nvimrc configuration repository (`luismayta/nvimrc`) into `~/.config/nvim` using git clone with depth=1. If the config directory already exists, cloning SHALL be skipped. The module SHALL provide a function to upgrade the config via git pull.

#### Scenario: First load — nvimrc not present
- **WHEN** the module loads and `~/.config/nvim` does not exist
- **THEN** the module SHALL run `git clone --depth=1` of the nvimrc repo into `~/.config/nvim`

#### Scenario: Subsequent load — nvimrc already present
- **WHEN** the module loads and `~/.config/nvim` already exists
- **THEN** the module SHALL skip cloning

#### Scenario: Upgrade nvimrc
- **WHEN** the user calls `nvim::upgrade`
- **THEN** the module SHALL run `git pull` inside `~/.config/nvim`

### Requirement: Cache and state cleanup

The module SHALL provide a function to clean Neovim caches and state directories.

#### Scenario: Clean all nvim caches
- **WHEN** the user calls `nvim::clean`
- **THEN** the module SHALL remove `~/.local/share/nvim`, `~/.cache/nvim`, `~/.local/state/nvim`, and the packer compiled file

### Requirement: vim command alias

The module SHALL define a `vim` shell function that delegates all arguments to `nvim`.

#### Scenario: vim command invokes nvim
- **WHEN** the user runs `vim <args>`
- **THEN** the shell SHALL execute `nvim <args>` with the same arguments

### Requirement: editnvim helper

The module SHALL define an `editnvim` shell function that opens the Neovim settings file using `$EDITOR`.

#### Scenario: editnvim with EDITOR set
- **WHEN** the user runs `editnvim` and `EDITOR` is set
- **THEN** the function SHALL execute `"${EDITOR}" "${NVIM_FILE_SETTINGS}"`

#### Scenario: editnvim with EDITOR unset
- **WHEN** the user runs `editnvim` and `EDITOR` is not set
- **THEN** the function SHALL print a warning and return without opening anything

### Requirement: Module idempotency

The module SHALL be safe to source multiple times. A guard variable SHALL prevent re-initialization on subsequent loads.

#### Scenario: Multiple sources
- **WHEN** the module's plugin.zsh is sourced a second time
- **THEN** the module SHALL return immediately without re-sourcing any sub-files

### Requirement: OS-specific dispatch

The module SHALL detect the operating system and source the appropriate OS-specific configuration and internal files. At minimum, macOS shall use its own overrides if present, and Linux shall fall back to defaults.

#### Scenario: macOS load
- **WHEN** the module loads on macOS (`darwin*`)
- **THEN** the module SHALL source the OS-specific file for each layer

#### Scenario: Linux load
- **WHEN** the module loads on Linux
- **THEN** the module SHALL source the Linux-specific file (or empty stub) for each layer

### Requirement: Public API functions

The module SHALL expose the following public functions via `pkg/base.zsh`:
- `nvim::install` — install nvimrc configuration
- `nvim::upgrade` — upgrade nvimrc configuration via git pull
- `nvim::clean` — clean nvim caches and state

#### Scenario: Public API availability
- **WHEN** the module has loaded
- **THEN** `nvim::install`, `nvim::upgrade`, and `nvim::clean` SHALL be available as shell functions

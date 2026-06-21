## ADDED Requirements

### Requirement: Module loads without errors
The nvim module SHALL load cleanly via plugin.zsh without producing errors or warnings.

#### Scenario: Plugin sources all layers
- **WHEN** zsh sources `zsh/modules/nvim/plugin.zsh`
- **THEN** config/main.zsh, internal/main.zsh, and pkg/main.zsh are sourced in order
- **THEN** no error or warning is emitted

#### Scenario: Guard prevents double-loading
- **WHEN** plugin.zsh is sourced a second time
- **THEN** `__ZSH_NVIM_LOADED` guard returns 0 and skips all layers

### Requirement: Data directory contains nvimrc configuration
The module SHALL include a `data/` directory with the nvimrc configuration files synced from `/home/lucho/Projects/src/github.com/luismayta/nvimrc`.

#### Scenario: Data directory has init.lua
- **WHEN** `zsh/modules/nvim/data/` is listed
- **THEN** `init.lua` exists
- **THEN** `lua/config/` directory exists with options.lua, keymaps.lua, autocmds.lua, lazy.lua, etc.

#### Scenario: Data directory mirrors nvimrc structure
- **WHEN** `zsh/modules/nvim/data/` is examined
- **THEN** it contains the same structure as `/home/lucho/Projects/src/github.com/luismayta/nvimrc` (init.lua, lua/config/, lua/plugins/)

### Requirement: Config layer defines all environment variables
The config layer SHALL define NVIM_CONFIG_PATH, NVIM_PACKAGE_NAME, NVIM_ROOT_PATH, and NVIM_FILE_SETTINGS with sensible defaults.

#### Scenario: Default variables are exported
- **WHEN** config/base.zsh is sourced
- **THEN** `NVIM_CONFIG_PATH` equals `$HOME/.config/nvim`
- **THEN** `NVIM_PACKAGE_NAME` equals `nvim`
- **THEN** `NVIM_ROOT_PATH` equals `$HOME/.config/nvim`
- **THEN** `NVIM_FILE_SETTINGS` equals `$NVIM_CONFIG_PATH/lua/config/options.lua`
- **THEN** `NVIM_PATH` equals the absolute path of `zsh/modules/nvim`

#### Scenario: OS dispatch picks correct overrides
- **WHEN** OSTYPE is `darwin*`
- **THEN** config/osx.zsh is sourced
- **WHEN** OSTYPE is `linux*`
- **THEN** config/linux.zsh is sourced

### Requirement: Internal layer syncs nvimrc configuration
The internal layer SHALL provide `nvim::internal::sync` that copies data/ to NVIM_CONFIG_PATH via rsync.

#### Scenario: Sync copies files from data/ to config path
- **WHEN** `nvim::internal::sync` is called
- **THEN** `rsync -avzh --progress` is executed from `$NVIM_PATH/data/` to `$NVIM_CONFIG_PATH/`
- **THEN** a success message is displayed

#### Scenario: Sync creates config directory if missing
- **WHEN** NVIM_CONFIG_PATH does not exist
- **WHEN** `nvim::internal::sync` is called
- **THEN** the directory is created
- **THEN** files are synced successfully

### Requirement: Internal layer cleans nvim caches
The internal layer SHALL provide `nvim::internal::clean` that removes Neovim cache and state directories.

#### Scenario: Clean removes all cache directories
- **WHEN** `nvim::internal::clean` is called
- **THEN** `$HOME/.local/share/nvim` is removed
- **THEN** `$HOME/.cache/nvim` is removed
- **THEN** `$HOME/.local/state/nvim` is removed
- **THEN** a success message is displayed

#### Scenario: Clean succeeds even if directories do not exist
- **WHEN** `nvim::internal::clean` is called
- **WHEN** one or more cache directories do not exist
- **THEN** the function completes without errors

### Requirement: Module auto-syncs nvimrc on load
The module SHALL automatically sync nvimrc configuration when the module loads and NVIM_CONFIG_PATH does not exist.

#### Scenario: Auto-sync on first load
- **WHEN** plugin.zsh is sourced
- **WHEN** NVIM_CONFIG_PATH does not exist
- **THEN** `nvim::internal::sync` is called automatically

### Requirement: Pkg layer provides public API
The pkg layer SHALL expose `nvim::sync`, `nvim::install`, `nvim::upgrade`, and `nvim::clean` as public wrappers.

#### Scenario: Public sync delegates to internal
- **WHEN** `nvim::sync` is called
- **THEN** `nvim::internal::sync` is invoked

#### Scenario: Public install calls sync
- **WHEN** `nvim::install` is called
- **THEN** `nvim::sync` is invoked (install = sync)

#### Scenario: Public upgrade calls sync
- **WHEN** `nvim::upgrade` is called
- **THEN** `nvim::sync` is invoked (upgrade = re-sync)

#### Scenario: Public clean delegates to internal
- **WHEN** `nvim::clean` is called
- **THEN** `nvim::internal::clean` is invoked with the same arguments

### Requirement: Alias vim maps to nvim
The module SHALL provide a `vim` function that delegates all arguments to `nvim`.

#### Scenario: vim function calls nvim
- **WHEN** `vim` is called with arguments
- **THEN** `nvim` is invoked with the same arguments

### Requirement: Helper editnvim opens nvim configuration
The module SHALL provide `editnvim` helper that opens the Neovim settings file in the default editor.

#### Scenario: editnvim with EDITOR set
- **WHEN** `EDITOR` is set
- **WHEN** `editnvim` is called
- **THEN** `$EDITOR` opens `$NVIM_FILE_SETTINGS`

#### Scenario: editnvim with EDITOR unset
- **WHEN** `EDITOR` is not set
- **WHEN** `editnvim` is called
- **THEN** an error message "EDITOR is not set" is printed to stderr
- **THEN** the function returns 1

#### Scenario: editnvim with NVIM_FILE_SETTINGS unset
- **WHEN** `EDITOR` is set
- **WHEN** `NVIM_FILE_SETTINGS` is not set
- **WHEN** `editnvim` is called
- **THEN** a warning is printed to stderr
- **THEN** `$EDITOR` opens `$NVIM_CONFIG_PATH` directory

### Requirement: Taskfile.yml provides lint target
The module SHALL include a Taskfile.yml with a `lint` target that checks Lua syntax.

#### Scenario: Lint checks Lua files in data/
- **WHEN** `task lint` is run in the module directory
- **THEN** all `.lua` files under `data/` are checked with `luac -p`
- **THEN** any syntax error causes the task to fail

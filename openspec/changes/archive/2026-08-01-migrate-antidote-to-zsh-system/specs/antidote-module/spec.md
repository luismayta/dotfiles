---
# Capability: antidote-module

## ADDED Requirements

### Requirement: Module registers with system loader
The SHALL be a module at `zsh/system/antidote/` with a `plugin.zsh` that registers with the zsh system loader. The module SHALL define an idempotency guard (`__ZSH_ANTIDOTE_LOADED`), SHALL set its module root path (`ZSH_ANTIDOTE_PATH` via `${0:A:h}`), SHALL emit `message_info "Loading module: antidote"`, and SHALL source its `config/`, `internal/` and `pkg/` layers. The module MUST respect `ZSH_DISABLED_MODULES`.

#### Scenario: Loader loads the antidote module
- **WHEN** the zshrc loader iterates over `${DOTFILES_SYSTEM_PATH}/*` and finds `zsh/system/antidote/plugin.zsh`
- **THEN** the module is sourced, the guard is set, and "Loading module: antidote" is emitted

#### Scenario: Module is disabled by the user
- **WHEN** `ZSH_DISABLED_MODULES` contains `antidote`
- **THEN** the loader skips the module and neither install nor init run

#### Scenario: Re-sourcing the module is a no-op
- **WHEN** `plugin.zsh` is sourced a second time in the same shell
- **THEN** the guard prevents re-execution

### Requirement: Install is idempotent and self-contained
The module SHALL install antidote by cloning `https://github.com/mattmc3/antidote.git` (depth 1) into `${ANTIDOTE_PATH}` (default `${ZDOTDIR:-${HOME}}/.antidote`) only when `${ANTIDOTE_PATH}/antidote.zsh` is missing. The install SHALL be guarded and idempotent, emitting `message_info` on success and on skip.

#### Scenario: First install clones the repository
- **WHEN** `${ANTIDOTE_PATH}/antidote.zsh` does not exist and the module loads
- **THEN** the repository is cloned with depth 1 into `${ANTIDOTE_PATH}` and a success message is emitted

#### Scenario: Already installed skips cloning
- **WHEN** `${ANTIDOTE_PATH}/antidote.zsh` already exists
- **THEN** the module does not clone and emits a skip message

#### Scenario: Clone failure fails fast
- **WHEN** the git clone command fails
- **THEN** the error propagates (strict mode) and the module does not continue loading

### Requirement: Init loads bundles preserving order
The module SHALL expose a public function `antidote::init` that: sources `${ANTIDOTE_PATH}/antidote.zsh`, ensures `~/.custom_zsh_plugins.txt` exists, concatenates `zsh/zsh_plugins.txt` and `~/.custom_zsh_plugins.txt` into `~/.zsh_plugins.txt`, and runs `antidote load ~/.zsh_plugins.txt`. `zsh/zshrc` SHALL invoke `antidote::init` at the same position as the previous inline block, preserving the load order (after the `zsh/modules` loader).

#### Scenario: Fresh init loads all plugins
- **WHEN** `antidote::init` runs with a valid `${ANTIDOTE_PATH}`
- **THEN** antidote is sourced, the bundle file is generated and all bundles from `zsh_plugins.txt` and the custom file are loaded

#### Scenario: Missing custom plugins file
- **WHEN** `~/.custom_zsh_plugins.txt` does not exist
- **THEN** it is created empty before concatenation and load proceeds

#### Scenario: Load order is preserved
- **WHEN** zshrc reaches the position of the former inline antidote block
- **THEN** `antidote::init` runs after the `zsh/modules` loader, matching the previous behavior

### Requirement: Legacy tools mechanism is removed
The provisioning mechanism for tool installers SHALL be removed: `APPS=("antidote")` in `provision/script/config/base.sh`, the `dotfiles_install_apps` loop in `provision/script/functions.sh`, and `TOOLS_PATH` in `provision/script/bootstrap.sh` SHALL be deleted, along with the `tools/antidote/` directory and the empty `tools/` directory. `ANTIDOTE_PATH` SHALL remain defined.

#### Scenario: No tool installers remain
- **WHEN** provision bootstrap runs after the migration
- **THEN** no `tools/*/install.sh` is executed and `TOOLS_PATH` is not defined

#### Scenario: Legacy installer is gone
- **WHEN** the filesystem is inspected for `tools/antidote/install.sh`
- **THEN** the file and the `tools/` directory do not exist, while `ANTIDOTE_PATH` remains available to the antidote module

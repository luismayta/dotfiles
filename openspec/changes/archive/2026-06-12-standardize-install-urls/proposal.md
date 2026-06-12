## Why

Currently, 8 of 10 zsh modules that perform tool installations use hardcoded URLs directly in their `internal/` implementation scripts, while only the `ai` module follows a clean config-driven pattern (`MODULE_INSTALL_URL_TOOL="https://..."` in `config/`, consumed by variables in `internal/`). This inconsistency makes URLs difficult to audit, override per-architecture, or update without editing implementation code. Standardizing on a config-driven install URL pattern improves maintainability, auditability, and cross-platform support.

## What Changes

- Define a project-wide convention for install URL variables: `<MODULE>_INSTALL_URL_<TOOL>` exported in `config/*.zsh` files
- Migrate hardcoded installation URLs from `internal/` to `config/` in the following modules: `fnm`, `rust`, `rvm`, `pyenv`, `nvim`, `scmbreeze`, `tmux`, `devops` (tfenv)
- Complete the partial migration in `goenv` (2 remaining hardcoded URLs)
- Update internal implementation files to reference the new config variables
- No behavioral changes — all URLs remain identical, only their declaration location changes

## Capabilities

### New Capabilities
- `install-url-convention`: Define the project-wide `_INSTALL_URL_*` variable naming convention, location (config files), and consumption pattern (internal files reference the variable)
- `fnm-install-url`: Extract fnm install URL to `config/base.zsh`
- `rust-install-url`: Extract rustup and cargo install URLs to `config/base.zsh`
- `rvm-install-url`: Extract rvm install and GPG key URLs to `config/base.zsh`
- `pyenv-install-url`: Extract pyenv git clone URL to `config/base.zsh`
- `nvim-install-url`: Extract nvim git clone URL (composed from repo var) to `config/base.zsh`
- `scmbreeze-install-url`: Extract scm_breeze git clone URL to `config/base.zsh`
- `tmux-install-url`: Extract tpm git clone URL to `config/base.zsh`
- `goenv-install-url`: Migrate remaining 2 hardcoded URLs in goenv internal to use config variables
- `devops-install-url`: Extract tfenv git clone URL to `config/tfenv.zsh`

### Modified Capabilities
- None — existing specs do not cover install URL patterns

## Impact

- **Modules modified**: `fnm`, `rust`, `rvm`, `pyenv`, `nvim`, `scmbreeze`, `tmux`, `goenv`, `devops` (9 modules)
- **Files changed**: Each module's `config/base.zsh` (create or append) and `internal/base.zsh` (replace hardcoded URLs with variable references)
- **Breaking changes**: None — all URLs are identical, only the declaration location changes
- **Dependencies**: None — each module is independently testable
## ADDED Requirements

### Requirement: Explicit handoff between bootstrap and provision
The system SHALL use `exec bash` with exported environment variables to hand off control from bootstrap (`install.sh`) to provision (`provision/script/run.sh`), instead of using `source`.

`install.sh` SHALL export `DOTFILES_ROOT` (absolute path to the cloned repo) and `DOTFILES_OS` (`Darwin` or `Linux`) before calling `exec bash`.

`provision/script/run.sh` SHALL NOT source `install.sh` functions — it receives context only via environment variables.

#### Scenario: install.sh hands off via exec bash
- **WHEN** `install.sh` completes package installation and repo cloning
- **THEN** it SHALL run `exec bash "${DOTFILES_ROOT}/provision/script/run.sh"`
- **AND** it SHALL export `DOTFILES_ROOT` and `DOTFILES_OS` before the exec
- **AND** no functions or variables from `install.sh` SHALL leak into the provision shell

### Requirement: Robust path resolution
Scripts SHALL derive structural paths from `BASH_SOURCE[0]` rather than relying on `pwd`.

`provision/script/bootstrap.sh` SHALL set `ROOT_DIR` using:
```bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
```

`provision/script/test.sh` SHALL use the same pattern instead of relative `source "script/bootstrap.sh"`.

#### Scenario: bootstrap.sh resolves paths from BASH_SOURCE
- **WHEN** `bootstrap.sh` is sourced from any working directory
- **THEN** `ROOT_DIR` SHALL equal the repo root regardless of `pwd`

### Requirement: Fail loud on missing sourced files
Sourcing critical files (config, messages, functions, lib) SHALL use explicit error checking.

Instead of:
```bash
[ -r "${file}" ] && source "${file}"
```

The system SHALL use:
```bash
[ -r "${file}" ] || { echo "FATAL: ${file} not found" >&2; exit 1; }
source "${file}"
```

This applies to all source calls in `install.sh`, `bootstrap.sh`, and `run.sh`.

#### Scenario: missing lib file aborts immediately
- **WHEN** `lib/common.sh` is missing and `install.sh` tries to source it
- **THEN** the script SHALL print `FATAL: lib/common.sh not found` to stderr
- **AND** exit with code 1

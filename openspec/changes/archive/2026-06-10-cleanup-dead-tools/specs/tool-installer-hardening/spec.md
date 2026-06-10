## ADDED Requirements

### Requirement: Harden git-extras installer with strict mode
The git-extras installer (`tools/git-extras/install.sh`) SHALL include `set -euo pipefail`, `trap ... ERR`, `readonly` for constants, and `local` for function-scoped variables.

#### Scenario: git-extras installer passes strict mode
- **WHEN** running `bash -n tools/git-extras/install.sh`
- **THEN** the script SHALL pass syntax check with no errors

#### Scenario: git-extras installer fails fast on curl error
- **WHEN** the `curl -sSL http://git.io/git-extras-setup` command fails
- **THEN** the script SHALL exit with code 1 (due to `set -e` + `pipefail`)

### Requirement: Harden fonts installer with strict mode
The fonts installer (`tools/fonts/install.sh`) SHALL include `set -euo pipefail`, `trap ... ERR`, `readonly` for constants, and `local` for function-scoped variables.

#### Scenario: fonts installer passes strict mode
- **WHEN** running `bash -n tools/fonts/install.sh`
- **THEN** the script SHALL pass syntax check with no errors

#### Scenario: fonts installer fails fast on missing font repo
- **WHEN** the `PATH_FONTS_REPO` directory does not exist and `find` returns non-zero
- **THEN** the script SHALL exit with code 1

### Requirement: Harden antidote installer with strict mode
The antidote installer (`tools/antidote/install.sh`) SHALL include `set -euo pipefail`, `trap ... ERR`, `readonly` for constants, and `local` for function-scoped variables.

#### Scenario: antidote installer passes strict mode
- **WHEN** running `bash -n tools/antidote/install.sh`
- **THEN** the script SHALL pass syntax check with no errors

#### Scenario: antidote installer fails fast on git clone failure
- **WHEN** the `git clone --depth=1` command for antidote fails
- **THEN** the script SHALL exit with code 1

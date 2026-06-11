## MODIFIED Requirements

### Requirement: Brew installation with OS dispatch
**EDIT**: Remove Linux dispatch. `brew::install` now only supports macOS.

The module SHALL provide `brew::install` which calls `brew::install::osx` on macOS.

#### Scenario: macOS brew install
- **WHEN** `brew::install::osx` is called on macOS
- **THEN** it SHALL run `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

### Requirement: Post-install package setup
**EDIT**: Remove Linux post-install scenarios. Post-install only runs on macOS.

The module SHALL provide `brew::post_install` to install additional packages after brew is available.

#### Scenario: Post-install on macOS
- **WHEN** `brew::post_install` runs on macOS
- **THEN** it SHALL install `jq`, `the_silver_searcher`, and `tree` via brew

### Requirement: Auto-install when brew not found
**EDIT**: Remove reference to `brew::load`. Auto-install no longer invokes `brew::load` (Linuxbrew-only function removed).

The module SHALL automatically install brew when not found.

#### Scenario: Auto-install triggers on missing brew
- **WHEN** the module is sourced and brew is not in PATH
- **THEN** it SHALL run `brew::install` and `brew::post_install` automatically

## REMOVED Requirements

### Requirement: PATH and environment setup
**Reason**: `brew::load` only exported Linuxbrew paths (`/home/linuxbrew/.linuxbrew`). No longer needed.
**Migration**: N/A — function and its scenarios are removed entirely.

### Requirement: Linux brew install
**Reason**: Linuxbrew no longer used.
**Migration**: N/A — `brew::install::linux` function removed.

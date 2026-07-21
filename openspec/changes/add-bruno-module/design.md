## Context

The dotfiles repository uses a three-layer ZSH module architecture (config → internal → pkg) to manage tool installations and configurations. Bruno is an open-source API client that needs to be integrated following this established pattern.

Current state: No Bruno module exists. Users must manually install Bruno via npm or package managers.

Stakeholders: Developer who uses Bruno for API testing and wants automated setup integrated with their shell environment.

## Goals / Non-Goals

**Goals:**
- Automate Bruno CLI installation via npm (`@usebruno/cli`)
- Automate Bruno desktop app installation via platform package managers
- Provide standard public functions: `bruno::setup`, `bruno::install`, `bruno::sync`
- Follow existing module architecture and naming conventions
- Support both macOS and Linux platforms

**Non-Goals:**
- Manage Bruno collections or configurations (user manages these directly)
- Provide aliases for Bruno CLI commands (keep it minimal)
- Integrate with CI/CD pipelines (CLI is for local development)

## Decisions

### Decision 1: Standalone module vs. adding to devops module

**Choice:** Create standalone `zsh/modules/bruno/` module

**Rationale:** 
- Bruno is an API client, not a DevOps tool (unlike k9s, helm, terraform in devops)
- Each tool gets its own module for clarity and maintainability
- Follows the pattern of `zed/`, `nvim/`, `docker/` as standalone tool modules

**Alternative considered:** Add Bruno to devops module as `pkg/bruno.zsh`
- Rejected: DevOps module is for infrastructure tools; Bruno is a development tool

### Decision 2: CLI installation method

**Choice:** npm global install (`npm install -g @usebruno/cli`)

**Rationale:**
- Official recommended method from Bruno documentation
- Consistent across platforms
- Node.js module already exists in the module system

**Alternative considered:** Binary download from website
- Rejected: npm provides version management and easier updates

### Decision 3: Desktop app installation

**Choice:** Platform-specific package managers (snap/flatpak on Linux, brew on macOS)

**Rationale:**
- Integrates with existing package management workflow
- Automatic updates through package manager
- Consistent with how other apps are installed (e.g., alacritty, ghostty)

**Alternative considered:** Direct .deb/.dmg download
- Rejected: More maintenance burden, no auto-updates

### Decision 4: Module toggle behavior

**Choice:** `ZSH_BRUNO_ENABLED` toggle controls both CLI and desktop installation

**Rationale:**
- Consistent with other modules (zed, docker)
- Single toggle for entire module functionality
- Users who don't use Bruno can disable completely

## Risks / Trade-offs

**[Risk] Node.js dependency** → Module requires Node.js to be installed first
- Mitigation: Document dependency; `core::ensure npm` in internal/main.zsh

**[Risk] Platform-specific desktop installation** → Different commands per OS
- Mitigation: Use OS dispatch pattern (osx.zsh / linux.zsh) already established

**[Trade-off] Global npm install** → Requires sudo on some systems
- Mitigation: Document npm global directory setup; use `core::ensure npm` which handles this

**[Trade-off] Desktop app optional** → Some users may only want CLI
- Mitigation: Separate functions for CLI vs desktop; CLI always installed, desktop optional via `bruno::setup`

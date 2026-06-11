## Context

The `zsh-rvm` module (hadenlabs/zsh-rvm) is a standalone zsh plugin providing RVM (Ruby Version Manager) integration. It handles RVM installation via GPG/curl, Ruby version management, gem package provisioning, and macOS OpenSSL@3 path integration. The module follows a similar `config/` / `internal/` / `pkg/` layout as dotfiles modules.

The source repo has ~240 lines of meaningful code across 10 files. The existing module loader (`hadenlabs/zsh-rvm`) is loaded as an external plugin. The goal is to bring it into `zsh/modules/rvm/` following the established conventions used by `git`, `brew`, `docker`, and other modules.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/rvm/` with proper `plugin.zsh` entry point and idempotency guard
- Port all meaningful functionality: RVM install, load, version management, gem packages
- Adapt to dotfiles conventions: `shellcheck` shebangs, `core::ensure`, flat-sourced config, `module::main::factory` pattern
- Preserve macOS OpenSSL@3 integration (critical for Ruby compilation on ARM)
- Ensure module auto-loads on shell start

**Non-Goals:**
- No functional changes to how RVM works (install, load, version management, gem install)
- No restructuring of the RVM install process itself
- No changes to the external repo (it stays as-is, we copy into the monorepo)
- No CI/test migration (CI is handled by dotfiles' existing CI)

## Decisions

### 1. Module entry point: `plugin.zsh` with idempotency guard
The source uses `zsh-rvm.zsh` as entry point. The dotfiles convention uses `plugin.zsh` with a `__ZSH_<MODULE>_LOADED` guard to prevent double-loading. We follow the convention.

### 2. Config architecture: flat sourcing vs factory functions
The source uses `*::config::main::factory` functions for OS dispatch. Most dotfiles modules (git, brew) use flat sourcing in `config/main.zsh`. We'll use flat sourcing for consistency — `config/main.zsh` sources `base.zsh` + OS file directly.

### 3. Internal auto-install: `core::ensure`
The source has inline checks in `internal/main.zsh` for curl, gpg, and rvm installation. Dotfiles convention uses `core::ensure` which handles idempotent installation. We refactor to use `core::ensure curl`, `core::ensure gpg`, and `core::ensure rvm` in `internal/main.zsh`.

### 4. macOS OpenSSL@3 kept as OS override
The `internal/osx.zsh` file has critical OpenSSL@3 path logic for Ruby compilation on Apple Silicon. This is preserved as an OS-specific override of `rvm::internal::version::install`.

### 5. Module variable: `ZSH_RVM_PATH`
Changed from deriving at load time (`dirname $0`) to the standard pattern used by other modules — set via `plugin.zsh` based on the script's location.

### 6. Public API wrappers kept thin
The `pkg/base.zsh` provides `rvm::install`, `rvm::load`, `rvm::upgrade`, `rvm::install::versions`, etc. These thin wrappers around internal functions are preserved.

## Risks / Trade-offs

- **[Risk]** Missing any subtle macOS-specific behavior in the ports.
  → **Mitigation**: The code is directly copied and adapted line-by-line; no logic is rewritten, only entry points and sourcing patterns.
- **[Risk]** Breaking existing RVM installations if the load path changes.
  → **Mitigation**: `rvm::internal::rvm::load` uses `RVM_ROOT` (~/.rvm) directly, independent of module path. Load behavior is identical.
- **[Risk]** GPG key servers may be unavailable during install.
  → **Mitigation**: This is an existing risk, not introduced by the migration. Not addressed here.

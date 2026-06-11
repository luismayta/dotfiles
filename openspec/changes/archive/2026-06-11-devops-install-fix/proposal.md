## Why

The `zsh/modules/devops/internal/kubectl.zsh` file contains three install functions (`kubecolor`, `crossplane`, `krew`) that bypass the project's established `core::install` abstraction layer, calling `brew install` and `curl | sh` directly. This is inconsistent with the rest of the codebase where all package installations go through `core::install` (which delegates to platform-specific logic via `core::internal::core::install`). Bypassing the abstraction creates maintainability gaps: platform-specific install paths (Linux vs macOS), error handling, and idempotency checks are all punted to each function instead of being handled centrally.

## What Changes

- `devops::kubectl::internal::kubecolor::install`: Replace direct `brew install hidetatz/tap/kubecolor` with `core::install kubecolor`
- `devops::kubectl::internal::crossplane::install`: Remove crossplane entirely — crossplane is no longer used in the project
- `devops::kubectl::internal::krew::install`: Replace manual tarball download/extraction with `core::install krew`
- Update `devops::kubectl::internal::main::factory` if guard conditions or function signatures change
- Remove install functions that become no-ops (single-line wrappers around `core::install`)

## Capabilities

### New Capabilities
- `kubectl-install-refactor`: Refactor of the three install functions in `kubectl.zsh` to use `core::install` instead of direct commands

### Modified Capabilities
- *(none — this is an internal refactor, no spec-level behavior changes)*

## Impact

- **File**: `zsh/modules/devops/internal/kubectl.zsh` — 3 functions rewritten, 1 factory function potentially updated
- **Dependencies**: Relies on `core::install` existing and supporting `kubecolor`, `crossplane`, and `krew` packages via Homebrew (macOS) and native package managers (Linux)
- **Behavior**: Idempotency via `core::exists` guard already present in factory and some install functions; `core::install` itself may add idempotency checks. Crossplane removed entirely (no longer used).
- **Regressions**: If any of these packages are not available via `core::install` on a given platform, the install will fail instead of silently proceeding — this is actually desired behavior (fail fast)
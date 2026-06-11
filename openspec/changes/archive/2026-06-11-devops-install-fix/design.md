## Context

The `zsh/modules/devops/internal/kubectl.zsh` file has three functions that install tools by directly calling system commands (`brew install`, `curl | sh`) instead of delegating to `core::install`. This is the last vestige of direct package manager calls in the codebase — every other module uses `core::install` to abstract platform-specific install logic.

The three affected functions:

1. `kubecolor::install` — calls `brew install hidetatz/tap/kubecolor` directly
2. `crossplane::install` — downloads and runs a shell script from `raw.githubusercontent.com`
3. `krew::install` — downloads a tarball from GitHub releases, extracts it, and runs the binary

All three packages (`kubecolor`, `crossplane-cli`, `krew`) are available as standard Homebrew formulas, making `core::install <package>` viable on macOS. On Linux, `core::install` delegates to the distribution's native package manager.

## Goals / Non-Goals

**Goals:**
- Replace all three install functions with `core::install` calls
- Remove functions that become trivial one-liners after the refactor
- Keep `krew::install` as a separate function only if it retains meaningful logic beyond `core::install krew`
- Maintain backward compatibility — the `main::factory` must still install all three tools

**Non-Goals:**
- Changing the `krew::load` or `completion::load` functions (unrelated)
- Refactoring `plugin::install` / `plugins::install` (those use `kubectl krew install`, not system installs)
- Changing the Go packages install loop (already uses `goenv::internal::package::install`)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Replace `brew install hidetatz/tap/kubecolor` | `core::install kubecolor` | `kubecolor` is now a standard Homebrew formula; `core::install` already wraps `brew install ${@}` on macOS |
| Replace `curl | sh` for crossplane | Remove crossplane entirely | Crossplane is no longer used in the project; removed from factory altogether |
| Replace tarball download for krew | `core::install krew` | `krew` is a standard Homebrew formula; `brew install krew` installs `kubectl-krew` |
| Remove `kubecolor::install` after refactor | Keep as `core::ensure kubecolor` | Function becomes a one-liner; integrate into `main::factory` directly |
| Remove `crossplane::install` after refactor | Keep as `core::ensure crossplane` | Same — one-liner in factory |
| Keep `krew::install` | Refactor body to `core::install krew` | Function name is descriptive; keeps `main::factory` readable |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Crossplane no longer used | Removed from factory entirely | Eliminates unnecessary dependency; no brew formula compatibility concerns |
| KREW install path expectation (historically downloads to tmpdir) | Brew installs to standard Cellar prefix; `kubectl krew` still works as expected |
| Linux fallback for `core::install` may not have these packages | Same risk as all other `core::install` consumers; consistent failure mode is better than silent platform bypass |

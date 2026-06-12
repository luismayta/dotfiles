## Context

The goenv module installs Go version management (via gobrew) and a suite of Go tools. The install function in `internal/base.zsh` calls `go install "${package}"` for each entry in `GOENV_INSTALL_PACKAGES`. However:

1. **Go 1.17+ requires `@version`**: `go install` outside a module requires `pkg@version`. The local packages are listed without `@latest`.
2. **Stale package list**: The current list includes deprecated vim-go-era tools (`gocode`, `go-outline`, `go-symbols`) that gopls has replaced, and is missing modern tools (ginkgo, goreleaser/v2, task, staticcheck, etc.) present in the upstream `hadenlabs/zsh-goenv`.
3. **golangci-lint install is broken**: Uses a pinned curl script for `v1.41.0` instead of `go install`.

The upstream repo `hadenlabs/zsh-goenv` has an up-to-date `config/base.zsh` with all packages listed with `@latest`.

## Goals / Non-Goals

**Goals:**
- Make `goenv::package::all::install` work with Go 1.17+ by adding `@latest` to all package entries
- Sync package list with upstream: add missing tools, remove deprecated ones
- Normalize golangci-lint installation to use `go install golangci-lint@latest` matching the rest
- Keep the 3-layer module architecture (config → internal → pkg) unchanged

**Non-Goals:**
- Not changing gobrew installation mechanism (still uses `curl | sh`)
- Not changing the auto-install/internals beyond the package install functions
- Not removing the `GOBREW_INSTALL_URL` and `GOENV_INSTALL_URL_LINT` variables if they're referenced elsewhere

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Package version strategy | `@latest` | Simpler than pinning specific versions; matches upstream pattern; auto-updates on reinstall |
| golangci-lint install | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` | Replace pinned v1.41.0 curl script; consistent with all other packages; upstream already uses this |
| Variable cleanup | Keep `GOENV_INSTALL_URL_LINT`, keep `GOBREW_INSTALL_URL` | May be referenced elsewhere or by users; removing doesn't fix the install bug |
| Category organization | Keep current `+=()` per-category style | More readable than upstream's single monolithic array; easier to maintain per category |
| Package list | Follow upstream content but adapt to `+=()` categories | Upstream has the canonical list; local structure has cleaner organization |

## Risks / Trade-offs

- **[Risk] `@latest` may break if upstream removes/changes API**: Unlikely for mature tools. Mitigation: most are widely-used (gopls, goreleaser, golangci-lint) with stable APIs.
- **[Risk] Some upstream packages may not exist for darwin/arm64**: Mitigation: all are standard Go tools, tested upstream. If one fails, `goenv::internal::package::install` shows a warning and continues.
- **[Trade-off] Dropping deprecated tools**: gocode, go-outline, go-symbols are no longer maintained but some editors may still reference them. Mitigation: gopls replaces all of them and is already in the list.

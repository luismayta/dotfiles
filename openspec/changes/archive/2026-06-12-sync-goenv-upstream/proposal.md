## Why

The goenv module install doesn't work. Go 1.17+ changed `go install` to require `pkg@version` syntax outside a module context, but the package list in `config/base.zsh` lists packages without version suffixes (e.g., `github.com/nsf/gocode` instead of `github.com/nsf/gocode@latest`). Additionally, the package list is stale — it includes deprecated vim-go-era tools and is missing many modern tools available in the upstream `hadenlabs/zsh-goenv` repository.

## What Changes

- **Add `@latest` suffix** to all Go packages in `config/base.zsh` so `go install` works with Go 1.17+
- **Sync package list** with upstream `hadenlabs/zsh-goenv/config/base.zsh`: replace deprecated packages, add missing tools, remove duplicates
- **Remove stale/duplicate variables** from `config/base.zsh` that don't exist upstream (e.g., `GOENV_INSTALL_URL_LINT`, `GOBREW_INSTALL_URL`)
- **Fix golangci-lint installation** in `internal/base.zsh`: replace the pinned `v1.41.0` curl install with the `@latest` go install pattern matching all other packages

## Capabilities

### New Capabilities
- `goenv-packages`: Go package list configuration and installation — defines which Go tools are installed, their versions (`@latest`), and the categories they belong to (development, testing, CI/CD, security, etc.)

### Modified Capabilities
<!-- No existing specs modified — this is a new capability -->

## Impact

- `zsh/modules/goenv/config/base.zsh`: rewritten `GOENV_INSTALL_PACKAGES` array with `@latest` suffixes and modernized package list
- `zsh/modules/goenv/internal/base.zsh`: fix golangci-lint install to use `go install` pattern instead of pinned curl script
- Downstream: `goenv::package::all::install` will now succeed with Go 1.17+; new tools will be available after install

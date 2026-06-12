## ADDED Requirements

### Requirement: Package list uses @version syntax
The `GOENV_INSTALL_PACKAGES` array SHALL include `@latest` suffix on every entry so `go install pkg@latest` works with Go 1.17+ module-aware mode.

#### Scenario: Install package with @latest
- **WHEN** `goenv::internal::package::install` is called with a package string
- **THEN** the package string SHALL include `@latest` (e.g., `github.com/golangci/golangci-lint/cmd/golangci-lint@latest`)
- **AND** `go install` SHALL succeed without "requires a version" error

### Requirement: Package list matches upstream
The package list SHALL include all tools from upstream `hadenlabs/zsh-goenv/config/base.zsh`, organized by category using `GOENV_INSTALL_PACKAGES+=()`.

#### Scenario: Kubernetes tools present
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL include `sigs.k8s.io/kustomize/kustomize/v5@latest`, `sigs.k8s.io/kind@v0.27.0`, and `github.com/particledecay/kconf@latest`

#### Scenario: Go development tools present
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL include `golang.org/x/tools/gopls@latest`, `golang.org/x/tools/cmd/goimports@latest`, `github.com/fatih/gomodifytags@latest`

#### Scenario: Testing tools present
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL include `github.com/onsi/ginkgo/v2/ginkgo@latest`, `github.com/vektra/mockery/v2@v2.38.0`

#### Scenario: Release & Build tools present
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL include `github.com/goreleaser/goreleaser/v2@latest`, `github.com/go-task/task/v3/cmd/task@latest`, `github.com/git-chglog/git-chglog/cmd/git-chglog@latest`

#### Scenario: Linting & quality tools present
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL include `honnef.co/go/tools/cmd/staticcheck@latest`, `github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.2`, `github.com/go-critic/go-critic/cmd/gocritic@latest`

### Requirement: Deprecated tools removed
Deprecated vim-go-era tools SHALL be removed from `GOENV_INSTALL_PACKAGES`.

#### Scenario: No deprecated tools
- **WHEN** `GOENV_INSTALL_PACKAGES` is sourced
- **THEN** it SHALL NOT include `github.com/nsf/gocode`, `github.com/uudashr/gopkgs/v2/cmd/gopkgs`, `github.com/ramya-rao-a/go-outline`, `github.com/acroca/go-symbols`, `github.com/haya14busa/goplay/cmd/goplay`

### Requirement: golangci-lint uses go install
The golangci-lint installation in `goenv::internal::packages::install` SHALL use `go install` with `@latest` instead of the pinned curl script.

#### Scenario: golangci-lint install via go install
- **WHEN** `goenv::internal::packages::install` is called
- **THEN** golangci-lint SHALL be installed via `go install` (not `curl | sh`)
- **AND** the pinned curl script for `v1.41.0` SHALL be removed

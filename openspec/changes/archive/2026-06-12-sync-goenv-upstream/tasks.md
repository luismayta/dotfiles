## 1. Sync package list with upstream

- [x] 1.1 Rewrite `config/base.zsh` `GOENV_INSTALL_PACKAGES` with `@latest` on every entry, following upstream `hadenlabs/zsh-goenv/config/base.zsh`
- [x] 1.2 Add missing categories/tools: Kubernetes (kustomize, kind, kconf), Testing (ginkgo, mockery), Linting (staticcheck, gocritic, gocyclo), Security (gitleaks, tfsec, subfinder), Infrastructure (myaws, aws-vault), Productivity (jira-cli, direnv, gomplate), Git (lazygit, gitsu, glab), etc.
- [x] 1.3 Remove deprecated vim-go-era tools (gocode, go-outline, go-symbols, goplay, gomvpkg, goyacc, gotype, stringer, golint, gopkgs)

## 2. Fix golangci-lint installation

- [x] 2.1 Remove pinned curl install (`GOENV_INSTALL_URL_LINT`) from `internal/base.zsh` `goenv::internal::packages::install` and add golangci-lint to `GOENV_INSTALL_PACKAGES` with `@latest`

## 3. Verify

- [x] 3.1 Run `task validate` for pre-commit hooks
- [x] 3.2 Verify shell syntax with `shellcheck` on modified files

## 1. Internal Implementation

- [ ] 1.1 Add `fnm::internal::package::install` function in `internal/base.zsh` that accepts a package name argument, validates it, and runs `bun install -g <package>`

## 2. Public Interface

- [ ] 2.1 Add `fnm::package::install` public delegating function in `pkg/base.zsh` that calls `fnm::internal::package::install`

## 3. Verification

- [ ] 3.1 Run `task validate` to confirm shellcheck and pre-commit hooks pass

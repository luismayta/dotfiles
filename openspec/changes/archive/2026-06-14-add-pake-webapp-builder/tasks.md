## 1. Config

- [x] 1.1 Add `APPS_WEB_APPS_BUILD` config array in `config/base.zsh` with `name:url` entries

## 2. Internal Implementation

- [x] 2.1 Add `apps::internal::webapp::build` function in `internal/base.zsh` that validates args and runs `pake <url> --name <name> --width 1200 --height 800 --hide-title-bar --targets zst`
- [x] 2.2 Add `apps::internal::webapp::all::build` function in `internal/base.zsh` that iterates `APPS_WEB_APPS_BUILD` and calls `apps::internal::webapp::build` for each

## 3. Public Interface

- [x] 3.1 Add `apps::webapp::build` public delegating function in `pkg/base.zsh`
- [x] 3.2 Add `apps::webapp::all::build` public delegating function in `pkg/base.zsh`

## 4. Verification

- [x] 4.1 Run `task validate` to confirm shellcheck and pre-commit hooks pass

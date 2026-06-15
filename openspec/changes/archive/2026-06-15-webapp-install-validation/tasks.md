## 1. Extract `is_installed()` helper

- [x] 1.1 Add `apps::internal::webapp::is_installed()` function in `webapp.zsh` that checks `core::exists pake-${(L)name}` on Linux and `[ -d "${APPLICATION_PATH}/${name}.app" ]` on macOS
- [x] 1.2 Suppress shellcheck SC2296 for `${(L)name}` pattern

## 2. Update `all::install()` idempotency check

- [x] 2.1 Replace `paru -Qi` guard (line 145) with call to `apps::internal::webapp::is_installed()`
- [x] 2.2 Remove the `OSTYPE == linux*` condition — delegate OS dispatch to `is_installed()`

## 3. Update `ensure()` idempotency check

- [x] 3.1 Replace `paru -Qi` guard (line 178) with call to `apps::internal::webapp::is_installed()`
- [x] 3.2 Remove the `OSTYPE == linux*` condition — delegate OS dispatch to `is_installed()`

## 4. Validate

- [x] 4.1 Run `shellcheck` on `webapp.zsh`
- [x] 4.2 Run `task validate` (includes pre-commit hooks)

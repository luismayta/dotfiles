## 1. Refactor internal layer

- [ ] 1.1 Modify `internal/base.zsh`: Change `nvim::internal::clean` to use `$NVIM_DATA_HOME`, `$NVIM_CACHE_HOME`, `$NVIM_STATE_HOME` with `: "${VAR:=default}"` fallback instead of hardcoded paths
- [ ] 1.2 Delete `internal/linux.zsh` — XDG vars are already in `config/linux.zsh`
- [ ] 1.3 Modify `internal/main.zsh`: Remove the `linux*)` case branch (no OS-specific file to source)

## 2. Refactor pkg layer

- [ ] 2.1 Delete `pkg/linux.zsh` — `nvim::clean::xdg` is no longer needed
- [ ] 2.2 Modify `pkg/main.zsh`: Remove the `linux*)` case branch (no OS-specific file to source)

## 3. Cleanup and verify

- [ ] 3.1 Verify no other references to `nvim::clean::xdg` exist in the repository
- [ ] 3.2 Source the module in a shell and test `nvim::clean` runs without errors
- [ ] 3.3 Run `task validate` to confirm pre-commit hooks pass

## 1. Fix Typos and Stubs

- [x] 1.1 Fix typo "method not implement" → "method not implemented" in `pkg/base.zsh`, `pkg/k9s.zsh`, `pkg/helm.zsh`
- [x] 1.2 Implement `devops::upgrade` by delegating to `core::upgrade` in `pkg/base.zsh`
- [x] 1.3 Implement `devops::k9s::upgrade` by delegating to `core::upgrade k9s` in `pkg/k9s.zsh`
- [x] 1.4 Implement `devops::helm::upgrade` by delegating to `core::upgrade helm` in `pkg/helm.zsh`
- [x] 1.5 Remove no-op `devops::helm::post_install` from `pkg/helm.zsh`

## 2. Cross-Platform k9s Config Sync

- [x] 2.1 Add `DEVOPS_K9S_CONF_PATH` platform override in `config/linux.zsh` (XDG path)
- [x] 2.2 Move default `DEVOPS_K9S_CONF_PATH` from `pkg/k9s.zsh` to `config/base.zsh` with macOS default *(was already in config/base.zsh — confirmed)*
- [x] 2.3 Verify `devops::k9s::sync` uses `DEVOPS_K9S_CONF_PATH` from config (already does, confirmed after changes)

## 3. Architectural Cleanup

- [x] 3.1 Remove `core::ensure helm` from `devops::kubectl::internal::main::factory` in `internal/kubectl.zsh`
- [x] 3.2 Replace `cd "${path_tfenv}" && git pull && cd -` with `git -C` in `internal/tfenv.zsh`
- [x] 3.3 Suppress `cd -` stdout with `> /dev/null 2>&1 || true` if `git -C` is not viable *(not needed — 3.2 succeeded with git -C)*

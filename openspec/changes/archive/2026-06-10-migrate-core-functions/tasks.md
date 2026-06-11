## 1. Migrate docker.zsh to devops module

- [x] 1.1 Copy `zsh/core/pkg/docker.zsh` to `zsh/modules/devops/pkg/docker.zsh`
- [x] 1.2 Add `source "${DEVOPS_PATH}/pkg/docker.zsh"` to `zsh/modules/devops/pkg/main.zsh`
- [x] 1.3 Remove `source "${DOTFILES_CORE_DIR}"/pkg/docker.zsh` from `zsh/core/pkg/main.zsh`
- [x] 1.4 Remove `zsh/core/pkg/docker.zsh`
- [x] 1.5 Syntax check (`zsh -n`) on all modified files
- [x] 1.6 Run `task validate`
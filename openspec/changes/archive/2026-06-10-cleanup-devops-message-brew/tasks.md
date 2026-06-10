## 1. Cleanup — Remove dead `CORE_MESSAGE_*` variables

- [ ] 1.1 Remove `CORE_MESSAGE_YAY` from `zsh/core/config/env.zsh:7`
- [ ] 1.2 Remove `CORE_MESSAGE_RVM` from `zsh/core/config/env.zsh:8`
- [ ] 1.3 Remove `CORE_MESSAGE_NVM` from `zsh/core/config/env.zsh:10`
- [ ] 1.4 Remove `CORE_MESSAGE_PYENV` from `zsh/core/config/env.zsh:12`

## 2. Cleanup — Remove dead `DEVOPS_*_MESSAGE_*` variables

- [ ] 2.1 Remove `DEVOPS_K9S_MESSAGE_BREW` from `zsh/modules/devops/config/base.zsh:24`
- [ ] 2.2 Remove `DEVOPS_K9S_MESSAGE_NOT_FOUND` from `zsh/modules/devops/config/base.zsh:25`
- [ ] 2.3 Remove `DEVOPS_KUBECTL_MESSAGE_BREW` from `zsh/modules/devops/config/base.zsh:31`
- [ ] 2.4 Remove `DEVOPS_KUBECTL_MESSAGE_NOT_FOUND` from `zsh/modules/devops/config/base.zsh:32`
- [ ] 2.5 Remove `DEVOPS_HELM_MESSAGE_BREW` from `zsh/modules/devops/config/base.zsh:85`
- [ ] 2.6 Remove `DEVOPS_HELM_MESSAGE_NOT_FOUND` from `zsh/modules/devops/config/base.zsh:86`
- [ ] 2.7 Remove `DEVOPS_TFENV_MESSAGE_BREW` from `zsh/modules/devops/config/base.zsh:92`

## 3. Cleanup — Remove module dead `MESSAGE_*` variables

- [ ] 3.1 Remove `ZSH_ALIASES_MESSAGE_NOT_FOUND` from `zsh/modules/aliases/config/base.zsh:5`
- [ ] 3.2 Remove `FNM_MESSAGE_NOT_FOUND` from `zsh/modules/fnm/config/base.zsh:3`
- [ ] 3.3 Remove `FNM_MESSAGE_CORE` from `zsh/modules/fnm/config/base.zsh:6`

## 4. Verify

- [ ] 4.1 Run `git grep 'CORE_MESSAGE_YAY\|CORE_MESSAGE_RVM\|CORE_MESSAGE_NVM\|CORE_MESSAGE_PYENV'` to confirm zero remaining references
- [ ] 4.2 Run `git grep 'DEVOPS_K9S_MESSAGE_BREW\|DEVOPS_KUBECTL_MESSAGE_BREW\|DEVOPS_HELM_MESSAGE_BREW\|DEVOPS_TFENV_MESSAGE_BREW'` to confirm zero references
- [ ] 4.3 Run `git grep 'DEVOPS_K9S_MESSAGE_NOT_FOUND\|DEVOPS_KUBECTL_MESSAGE_NOT_FOUND\|DEVOPS_HELM_MESSAGE_NOT_FOUND'` to confirm zero references
- [ ] 4.4 Run `git grep 'ZSH_ALIASES_MESSAGE_NOT_FOUND\|FNM_MESSAGE_NOT_FOUND\|FNM_MESSAGE_CORE'` to confirm zero references
- [ ] 4.5 Run `task validate` to confirm pre-commit hooks pass
- [ ] 4.6 Run `zsh -n` on each modified file to verify syntax

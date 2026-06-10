## 1. Core ensure function

- [ ] 1.1 Add `core::ensure` function to `zsh/core/pkg/base.zsh`

## 2. Devops module

- [ ] 2.1 Replace guard in `devops/internal/helm.zsh`
- [ ] 2.2 Replace guard in `devops/internal/k9s.zsh`
- [ ] 2.3 Replace guards in `devops/internal/kubectl.zsh` (kubectl, helm, kubectx)
- [ ] 2.4 Replace guards in `devops/internal/tfenv.zsh` (curl, terragrunt, terraform-docs)

## 3. Git family

- [ ] 3.1 Replace guards in `git/internal/main.zsh` (git, hub, rsync, git-flow)
- [ ] 3.2 Replace guard in `scmbreeze/internal/main.zsh`

## 4. Other modules

- [ ] 4.1 Replace guards in `notify/internal/main.zsh` and `notify/internal/osx.zsh`
- [ ] 4.2 Replace guards in `fnm/pkg/base.zsh` (curl, unzip)
- [ ] 4.3 Replace guard in `goenv/internal/main.zsh`
- [ ] 4.4 Replace guard in `pyenv/internal/main.zsh`

## 5. Validation

- [ ] 5.1 Run `zsh -n` syntax check on all modified files
- [ ] 5.2 Verify no remaining instances of the manual guard pattern in modules
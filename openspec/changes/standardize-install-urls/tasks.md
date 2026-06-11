## 1. Establish Install URL Convention

- [x] 1.1 Document the `_INSTALL_URL_*` naming convention in project guidelines (if applicable)
- [x] 1.2 Verify convention matches existing `AI_INSTALL_URL_*` pattern as reference

## 2. Migrate fnm Module

- [x] 2.1 Add `export FNM_INSTALL_URL="https://fnm.vercel.app/install"` to `zsh/modules/fnm/config/base.zsh`
- [x] 2.2 Update `zsh/modules/fnm/internal/base.zsh` to use `${FNM_INSTALL_URL}` instead of hardcoded URL
- [x] 2.3 Run `task validate` to confirm pre-commit hooks pass

## 3. Migrate rust Module

- [x] 3.1 Add `export RUST_INSTALL_URL_RUSTUP="https://sh.rustup.rs"` to `zsh/modules/rust/config/base.zsh`
- [x] 3.2 Add `export RUST_INSTALL_URL_UV="https://github.com/astral-sh/uv"` to `zsh/modules/rust/config/base.zsh`
- [x] 3.3 Update `zsh/modules/rust/internal/base.zsh` to use `${RUST_INSTALL_URL_RUSTUP}` instead of hardcoded URL
- [x] 3.4 Update `zsh/modules/rust/config/base.zsh` to use `${RUST_INSTALL_URL_UV}` instead of hardcoded URL
- [x] 3.5 Run `task validate` to confirm pre-commit hooks pass

## 4. Migrate rvm Module

- [x] 4.1 Add `export RVM_INSTALL_URL="https://get.rvm.io"` to `zsh/modules/rvm/config/base.zsh`
- [x] 4.2 Add `export RVM_INSTALL_URL_MPAPIS="https://rvm.io/mpapis.asc"` to `zsh/modules/rvm/config/base.zsh`
- [x] 4.3 Add `export RVM_INSTALL_URL_PKUCZYNSKI="https://rvm.io/pkuczynski.asc"` to `zsh/modules/rvm/config/base.zsh`
- [x] 4.4 Update `zsh/modules/rvm/internal/base.zsh` to use URL variables instead of hardcoded URLs
- [x] 4.5 Update `zsh/modules/rvm/internal/osx.zsh` to use `${RVM_INSTALL_URL}` instead of hardcoded URL
- [x] 4.6 Run `task validate` to confirm pre-commit hooks pass

## 5. Migrate pyenv Module

- [x] 5.1 Add `export PYENV_INSTALL_URL="https://github.com/pyenv/pyenv.git"` to `zsh/modules/pyenv/config/base.zsh`
- [x] 5.2 Update `zsh/modules/pyenv/internal/base.zsh` to use `${PYENV_INSTALL_URL}` instead of hardcoded URL
- [x] 5.3 Run `task validate` to confirm pre-commit hooks pass

## 6. Migrate nvim Module

- [x] 6.1 Add `export NVIM_INSTALL_URL="https://github.com/luismayta/nvimrc.git"` to `zsh/modules/nvim/config/base.zsh`
- [x] 6.2 Keep existing `NVIM_REPO_HTTPS` for backward compatibility
- [x] 6.3 Update `zsh/modules/nvim/internal/base.zsh` to use `${NVIM_INSTALL_URL}` instead of composing URL from repo path
- [x] 6.4 Run `task validate` to confirm pre-commit hooks pass

## 7. Migrate scmbreeze Module

- [x] 7.1 Add `export SCMBREEZE_INSTALL_URL="https://github.com/scmbreeze/scm_breeze.git"` to `zsh/modules/scmbreeze/config/base.zsh`
- [x] 7.2 Update `zsh/modules/scmbreeze/internal/base.zsh` to use `${SCMBREEZE_INSTALL_URL}` instead of hardcoded URL
- [x] 7.3 Run `task validate` to confirm pre-commit hooks pass

## 8. Migrate tmux Module

- [x] 8.1 Add `export TMUX_INSTALL_URL_TPM="https://github.com/tmux-plugins/tpm"` to `zsh/modules/tmux/config/base.zsh`
- [x] 8.2 Update `zsh/modules/tmux/internal/base.zsh` to use `${TMUX_INSTALL_URL_TPM}` instead of hardcoded URL
- [x] 8.3 Run `task validate` to confirm pre-commit hooks pass

## 9. Complete goenv Migration

- [x] 9.1 Add `export GOENV_INSTALL_URL_LINT="https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh"` to `zsh/modules/goenv/config/base.zsh`
- [x] 9.2 Add `export GOBREW_INSTALL_URL="https://git.io/gobrew"` to `zsh/modules/goenv/config/base.zsh`
- [x] 9.3 Keep existing `GOBREW_DOWNLOAD_URL` for backward compatibility
- [x] 9.4 Update `zsh/modules/goenv/internal/base.zsh` to use `${GOENV_INSTALL_URL_LINT}` and `${GOBREW_INSTALL_URL}` instead of hardcoded URLs
- [x] 9.5 Run `task validate` to confirm pre-commit hooks pass

## 10. Migrate devops Module (tfenv)

- [x] 10.1 Add `export DEVOPS_INSTALL_URL_TFENV="https://github.com/tfutils/tfenv.git"` to `zsh/modules/devops/config/tfenv.zsh`
- [x] 10.2 Update `zsh/modules/devops/internal/tfenv.zsh` to use `${DEVOPS_INSTALL_URL_TFENV}` instead of hardcoded URL
- [x] 10.3 Run `task validate` to confirm pre-commit hooks pass

## 11. Final Verification

- [x] 11.1 Run `git grep` across all modules to confirm no hardcoded install URLs remain in internal/ files
- [x] 11.2 Run `task validate` globally to confirm no regressions
- [x] 11.3 Verify `git status --porcelain` shows only expected changes
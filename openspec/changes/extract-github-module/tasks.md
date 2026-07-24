## 1. Create github module structure

- [ ] 1.1 Create directory structure: `zsh/modules/github/{config,internal,pkg,data/gh}`
- [ ] 1.2 Create `zsh/modules/github/plugin.zsh` with guard pattern and ZSH_GITHUB_ENABLED toggle
- [ ] 1.3 Create `zsh/modules/github/config/gh.zsh` with ZSH_GITHUB_* variables

## 2. Migrate internal functions

- [ ] 2.1 Create `zsh/modules/github/internal/gh.zsh` with github::internal::* functions
- [ ] 2.2 Migrate `devops::gh::internal::main::factory` → `github::internal::main::factory`
- [ ] 2.3 Migrate `devops::gh::internal::install_completions` → `github::internal::install_completions`
- [ ] 2.4 Migrate `devops::gh::internal::install_dash` → `github::internal::install_dash`
- [ ] 2.5 Migrate `devops::gh::internal::load` → `github::internal::load`
- [ ] 2.6 Add auto-install logic with `core::exists gh` guard

## 3. Migrate public functions and aliases

- [ ] 3.1 Create `zsh/modules/github/pkg/gh.zsh` with github::* functions
- [ ] 3.2 Migrate `devops::gh::install` → `github::install`
- [ ] 3.3 Migrate `devops::gh::upgrade` → `github::upgrade`
- [ ] 3.4 Migrate `devops::gh::post_install` → `github::post_install`
- [ ] 3.5 Migrate `devops::gh::sync` → `github::sync`
- [ ] 3.6 Copy `ghd` alias and `editghdash` function

## 4. Migrate data directory

- [ ] 4.1 Copy `zsh/modules/devops/data/gh/config.yaml` → `zsh/modules/github/data/gh/config.yaml`

## 5. Update devops module

- [ ] 5.1 Remove `source "${DEVOPS_PATH}/config/gh.zsh"` from `devops/config/main.zsh`
- [ ] 5.2 Remove `source "${DEVOPS_PATH}/internal/gh.zsh"` from `devops/internal/main.zsh`
- [ ] 5.3 Remove `source "${DEVOPS_PATH}/pkg/gh.zsh"` from `devops/pkg/main.zsh`
- [ ] 5.4 Remove `github-cli` from `DEVOPS_TOOLS` array in `devops/config/base.zsh`

## 6. Cleanup old devops GH files

- [ ] 6.1 Delete `zsh/modules/devops/config/gh.zsh`
- [ ] 6.2 Delete `zsh/modules/devops/internal/gh.zsh`
- [ ] 6.3 Delete `zsh/modules/devops/pkg/gh.zsh`
- [ ] 6.4 Delete `zsh/modules/devops/data/gh/` directory

## 7. Verification

- [ ] 7.1 Test that devops module loads without errors
- [ ] 7.2 Test that github module loads without errors
- [ ] 7.3 Test that `gh` command is available
- [ ] 7.4 Test that `gh dash` alias works
- [ ] 7.5 Test that `editghdash` function works

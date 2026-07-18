## 1. Config Layer

- [x] 1.1 Create `config/atuin.zsh` with `DEVOPS_ATUIN_PACKAGE_NAME`, `DEVOPS_ATUIN_CONFIG_DIR`, `DEVOPS_ATUIN_INIT_FLAGS` variables
- [x] 1.2 Add `atuin` to `DEVOPS_TOOLS` array in `config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Create `internal/atuin.zsh` with `devops::atuin::internal::main::factory` function (load path, check exists, install if missing, init shell integration)
- [x] 2.2 Create `devops::atuin::internal::install` function using official curl installer
- [x] 2.3 Create `devops::atuin::internal::upgrade` function
- [x] 2.4 Add `source "${DEVOPS_PATH}/internal/atuin.zsh"` to `internal/main.zsh`

## 3. Pkg Layer

- [x] 3.1 Create `pkg/atuin.zsh` with `devops::atuin::install`, `devops::atuin::upgrade`, `devops::atuin::post_install` public functions
- [x] 3.2 Add `source "${DEVOPS_PATH}/pkg/atuin.zsh"` to `pkg/main.zsh`

## 4. Verification

- [ ] 4.1 Verify module loads without errors in a new ZSH session
- [ ] 4.2 Verify `atuin --version` returns successfully after install
- [ ] 4.3 Verify Ctrl-R triggers Atuin search

## 1. Configuration

- [ ] 1.1 Create `config/bruno.zsh` with package name, CLI package, and install command variables
- [ ] 1.2 Update `config/main.zsh` to source the new bruno config

## 2. Internal Functions

- [ ] 2.1 Create `internal/bruno.zsh` with `devops::bruno::internal::load` function
- [ ] 2.2 Implement `devops::bruno::internal::install` function using npm
- [ ] 2.3 Implement `devops::bruno::internal::upgrade` function
- [ ] 2.4 Implement `devops::bruno::internal::main::factory` for auto-install on load
- [ ] 2.5 Update `internal/main.zsh` to source the new bruno internal

## 3. Verification

- [ ] 3.1 Test module loads with `ZSH_DEVOPS_ENABLED=true`
- [ ] 3.2 Verify `bru` command is available after installation
- [ ] 3.3 Verify all functions are accessible via `type` command

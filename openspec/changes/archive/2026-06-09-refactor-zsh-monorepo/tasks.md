## 1. Core Structure

- [ ] 1.1 Create `zsh/modules/` directory with `.gitkeep`
- [ ] 1.2 Create `zsh/modules/README.md` explaining the module convention

## 2. Entry Point Update

- [ ] 2.1 Update `zsh/zshrc` to source `modules/*/plugin.zsh` files after loading mod/main.zsh
- [ ] 2.2 Ensure loading is alphabetical and skips missing plugin.zsh gracefully

## 3. Example Module

- [ ] 3.1 Create example module `zsh/modules/example/plugin.zsh` as reference

## 4. Verification

- [ ] 4.1 Source zshrc in subshell and confirm no errors
- [ ] 4.2 Verify existing mod/ functionality unchanged (aliases, functions, env vars)
- [ ] 4.3 Verify modules load in correct order
- [ ] 4.4 Run `task validate` to confirm pre-commit passes

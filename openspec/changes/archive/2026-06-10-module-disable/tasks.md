## 1. Reorder customrc before module loading loop

- [x] 1.1 Move the `.customrc` source block (currently line 42-43) to **before** the module loading loop (before line 23), so `ZSH_DISABLED_MODULES` is available when modules are iterated

## 2. Modify module loading loop in zshrc

- [x] 2.1 Add skip logic to the `for __module_dir` loop in `zsh/zshrc`: check if the basename of `__module_dir` is in `ZSH_DISABLED_MODULES` (space- or comma-delimited) before sourcing `plugin.zsh`
- [x] 2.2 Add inline comment above the loop explaining how to disable modules via `ZSH_DISABLED_MODULES`

## 3. Create config template and auto-bootstrap

- [x] 3.1 Create `.customrc.example` in repo root with commented-out `ZSH_DISABLED_MODULES` examples (single, multiple, comma-separated)
- [x] 3.2 Add auto-bootstrap logic to `zsh/zshrc`: if `~/.customrc` doesn't exist, copy `.customrc.example` from `DOTFILES_DIR`
- [x] 3.3 Copy `.customrc.example` to `~/.dotfiles/.customrc.example` (deployed location)
- [x] 3.4 Remove old manually-created `~/.customrc` (now auto-generated on next zshrc source)

## 4. Document disable mechanism

- [x] 4.1 Update `zsh/modules/README.md` with a "Disabling a module" section documenting the `ZSH_DISABLED_MODULES` environment variable

## 5. Verify

- [x] 5.1 Source the updated zshrc with `ZSH_DISABLED_MODULES="tmux"` and confirm tmux module is skipped
- [x] 5.2 Source the updated zshrc with `ZSH_DISABLED_MODULES=""` (empty) and confirm all modules load
- [x] 5.3 Source the updated zshrc with `ZSH_DISABLED_MODULES` unset and confirm all modules load
- [x] 5.4 Source the updated zshrc with `ZSH_DISABLED_MODULES="tmux,starship"` and confirm comma-delimited parsing works

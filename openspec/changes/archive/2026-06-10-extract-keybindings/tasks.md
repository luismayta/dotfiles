## 1. ghq module

- [ ] 1.1 Create `zsh/modules/ghq/keybindings.zsh` with `zle -N ghq::find::project` and `bindkey '^Xp' ghq::find::project`
- [ ] 1.2 Remove `zle -N ghq::find::project` and `bindkey '^Xp' ghq::find::project` from `zsh/modules/ghq/pkg/base.zsh`
- [ ] 1.3 Source `keybindings.zsh` from `zsh/modules/ghq/plugin.zsh` after the `pkg/main.zsh` source line

## 2. ssh module

- [ ] 2.1 Create `zsh/modules/ssh/keybindings.zsh` with `zle -N ssh::connect` and `bindkey '^Xs' ssh::connect`
- [ ] 2.2 Remove `zle -N ssh::connect` and `bindkey '^Xs' ssh::connect` from `zsh/modules/ssh/plugin.zsh`
- [ ] 2.3 Source `keybindings.zsh` from `zsh/modules/ssh/plugin.zsh` after the `pkg/main.zsh` source line

## 3. templates module

- [ ] 3.1 Create `zsh/modules/templates/keybindings.zsh` with `zle -N templates::run` and `bindkey '^Xt' templates::run`
- [ ] 3.2 Remove `zle -N templates::run` and `bindkey '^Xt' templates::run` from `zsh/modules/templates/plugin.zsh`
- [ ] 3.3 Source `keybindings.zsh` from `zsh/modules/templates/plugin.zsh` after the `pkg/main.zsh` source line

## 4. bitwarden module

- [ ] 4.1 Create `zsh/modules/bitwarden/keybindings.zsh` with `zle -N fbw` and `bindkey '^Xk' fbw`
- [ ] 4.2 Remove `zle -N fbw` and `bindkey '^Xk' fbw` from `zsh/modules/bitwarden/plugin.zsh`
- [ ] 4.3 Source `keybindings.zsh` from `zsh/modules/bitwarden/plugin.zsh` after the `pkg/main.zsh` source line

## 5. Verification

- [ ] 5.1 Run `task validate` to confirm no lint violations
- [ ] 5.2 Run `zsh -n` on all 4 new `keybindings.zsh` and all 4 modified `plugin.zsh` files
- [ ] 5.3 Confirm no `bindkey` or `zle -N` calls remain outside `keybindings.zsh` files

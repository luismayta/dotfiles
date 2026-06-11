## 1. Clean up brew module code and other linuxbrew refs

- [ ] 1.1 Remove `brew::load` function from `zsh/modules/brew/pkg/base.zsh` (lines 2-50), keep the auto-install guard below it
- [ ] 1.2 Remove `brew::install::linux` function from `zsh/modules/brew/internal/base.zsh` (lines 18-21)
- [ ] 1.3 Remove `linux*)` branch from `brew::install` in `zsh/modules/brew/internal/base.zsh` (lines 30-32)
- [ ] 1.4 Remove `linux*)` branch from `brew::post_install` in `zsh/modules/brew/internal/base.zsh` (lines 48-58)
- [ ] 1.5 Remove `linux*)` case from `zsh/modules/brew/internal/main.zsh` (lines 7-10)
- [ ] 1.6 Delete file `zsh/modules/brew/internal/linux.zsh`
- [ ] 1.7 Remove linuxbrew PATH block from `zsh/zshenv` (lines 43-45)

## 2. Verification

- [ ] 2.1 Confirm `brew::load` no longer exists in the module
- [ ] 2.2 Confirm `brew::install::linux` no longer exists
- [ ] 2.3 Confirm no references to `/home/linuxbrew/` or `.linuxbrew` remain in `zsh/modules/brew/`
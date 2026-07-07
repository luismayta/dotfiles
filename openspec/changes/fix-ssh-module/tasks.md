## 1. Fix ssh::list — replace less with file redirection

- [x] 1.1 Edit `internal/base.zsh`: replace `less "${SSH_CONFIG_FILE}" | grep ...` with `<"${SSH_CONFIG_FILE}" grep ...` pattern

## 2. Fix ssh::connect — cross-platform clipboard support

- [x] 2.1 Edit `internal/base.zsh`: replace `ghead -c -1` with `print -n` (zsh-native)
- [x] 2.2 Edit `internal/base.zsh`: add OS dispatch for clipboard — `pbcopy` on macOS, `xclip -selection clipboard` on Linux, `wl-copy` as Wayland fallback
- [~] 2.3 ~~Add `core::install xclip` dependency guard~~ — **Won't do**: per design decision, clipboard tools are user-choice on Linux; `ssh::connect` already provides a clear error message if neither `xclip` nor `wl-copy` is found

## 3. Fix security — StrictHostKeyChecking

- [x] 3.1 Edit `data/assh.yml`: change `StrictHostKeyChecking: no` to `StrictHostKeyChecking: ask`

## 4. Remove dead code

- [x] 4.1 Edit `config/base.zsh`: remove the `SSH_MESSAGE_NVM` export line

## 5. Clean up empty stub files and simplify OS dispatch

- [x] 5.1 Remove empty stub files: `config/linux.zsh`, `config/osx.zsh`, `internal/helper.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `pkg/helper.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh` (9 files)
- [x] 5.2 Edit `config/main.zsh`: remove OS-dispatch case block, keep only `source config/base.zsh`
- [x] 5.3 Edit `internal/main.zsh`: remove OS-dispatch case block and helper source, keep only `source internal/base.zsh`
- [x] 5.4 Edit `pkg/main.zsh`: remove OS-dispatch case block and helper source, keep only `source pkg/base.zsh` and `source pkg/alias.zsh`

## 6. Verify

- [x] 6.1 Run `zsh -n` syntax check on all modified `.zsh` files — **5/5 passed**
- [x] 6.2 Source the module in a zsh shell and test `ssh::list` works — **ok (exit 0)**
- [x] 6.3 Source the module and test `ssh::connect` / fzf workflow — **ok (function loads correctly, requires interactive fzf)

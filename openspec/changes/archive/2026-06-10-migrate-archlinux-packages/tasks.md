## 1. Bootstrap: Add missing packages to install.sh setup::linux

- [x] 1.1 Add `zsh`, `ksh`, `fd` to `install.sh` `setup::linux` package list alongside existing `git`, `go`, `npm`, `yarn`, `gcc`, `rsync`

## 2. Core: Add fd auto-install

- [x] 2.1 Add `if ! core::exists fd; then core::install fd; fi` to `zsh/core/pkg/helper/core.zsh`

## 3. Provision: Create desktop.sh and update functions.sh

- [x] 3.1 Create `provision/script/desktop.sh` with all desktop environment packages from `archlinux.sh` (i3, audio, fonts, theming, apps, PDF, utilities), organized by category
- [x] 3.2 Update `provision/script/functions.sh` `dotfiles_install_factory` to source `provision/script/desktop.sh` instead of `archlinux.sh`

## 4. Remove orphaned archlinux.sh

- [x] 4.1 Delete `archlinux.sh` from project root
- [x] 4.2 Ensure no other references to `archlinux.sh` remain in the codebase (only in change artifacts)

## 5. Final verification

- [x] 5.1 Run syntax check on all modified files
- [x] 5.2 Verify `install.sh` `setup::linux` has correct package list
- [x] 5.3 Verify `desktop.sh` contains all 34 formerly orphaned packages
- [x] 5.4 Verify `archlinux.sh` is fully removed
## 1. Remove dead tool installers

- [x] 1.1 Remove `tools/antibody/` directory (install.sh only file)
- [x] 1.2 Remove `tools/brew/` directory (install.sh only file)
- [x] 1.3 Remove `tools/wakatime/` directory (install.sh only file)

## 2. Harden active tool installers

- [x] 2.1 Harden `tools/git-extras/install.sh` with `set -euo pipefail`, `trap ... ERR`, `readonly`, and `local`
- [x] 2.2 Harden `tools/fonts/install.sh` with `set -euo pipefail`, `trap ... ERR`, `readonly`, and `local`
- [x] 2.3 Harden `tools/antidote/install.sh` with `set -euo pipefail`, `trap ... ERR`, `readonly`, and `local`

## 3. Verification

- [x] 3.1 Run `task validate` to confirm pre-commit hooks pass (shellcheck, codespell)
- [x] 3.2 Run `bash -n` on all 3 hardened installers to confirm syntax
- [x] 3.3 Confirm `git status --porcelain` shows only expected changes
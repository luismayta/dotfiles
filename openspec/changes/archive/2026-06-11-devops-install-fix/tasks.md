## 1. Refactor kubecolor install

- [x] 1.1 Replace `brew install hidetatz/tap/kubecolor` in `devops::kubectl::internal::kubecolor::install` with `core::install kubecolor`, keeping the `core::exists` guard

## 2. Refactor crossplane install

- [x] 2.1 Replace the `curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh` pipeline with `core::install crossplane` in `devops::kubectl::internal::crossplane::install`
- [x] 2.2 Remove the `mv crossplane "${DEVOPS_KUBECTL_LOCAL_PATH_BIN}/"` line (brew handles binary placement)
- [x] 2.3 Remove crossplane entirely from `main::factory` — crossplane is no longer used in the project

## 3. Refactor krew install

- [x] 3.1 Replace the tarball download/extract/run logic in `devops::kubectl::internal::krew::install` with `core::install krew`, keeping the `core::exists` guard

## 4. Clean up factory and remove dead code

- [x] 4.1 If `kubecolor::install` becomes a trivial one-liner, inline it into `main::factory` as `core::ensure kubecolor` and remove the function
- [x] 4.2 If `crossplane::install` becomes a trivial one-liner, inline it into `main::factory` as `core::ensure crossplane` and remove the function

## 5. Verify

- [x] 5.1 Source the updated zshrc and confirm kubecolor, crossplane, and krew install without errors on macOS
- [x] 5.2 Confirm no `brew install` or `curl.*install.sh` calls remain in `kubectl.zsh` (grep for `brew install`, `curl.*|.*sh`)

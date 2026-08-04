## 1. Internal Implementation

- [x] 1.1 Create `zsh/modules/herdr/internal/update.zsh` with `herdr::internal::update` running the official installer `curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh`
- [x] 1.2 Validate binary availability with `core::exists herdr` after the installer and return exit code `0`/`1` accordingly (mirror `herdr::internal::install` semantics)

## 2. Public API

- [x] 2.1 Add `herdr::update` to `zsh/modules/herdr/pkg/base.zsh` delegating to `herdr::internal::update`

## 3. Documentation

- [x] 3.1 Write `docs/guides/implement-module-update.md` documenting the generic `update` function pattern, using herdr as the reference implementation
- [x] 3.2 Cross-reference the new guide from `docs/guides/implement-tool-in-module.md` if applicable

## 4. Verification

- [x] 4.1 Run `bash -n` and shellcheck clean on all touched files
- [x] 4.2 Verify `herdr::update` returns `0` when herdr is available in PATH after the update
- [x] 4.3 Verify `herdr::update` returns `1` when the installer fails
- [x] 4.4 Verify `herdr::update` returns `1` when the binary is missing from PATH after the update
- [x] 4.5 Run `task validate` (pre-commit) clean

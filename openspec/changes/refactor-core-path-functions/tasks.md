## 1. Function Renaming in Definition Files

- [x] 1.1 Rename `path::prepend` to `core::path::prepend` in `internal/path.zsh`
- [x] 1.2 Rename `path::append` to `core::path::append` in `internal/path.zsh`
- [x] 1.3 Rename `path::clean` to `core::path::clean` in `internal/path.zsh`
- [x] 1.4 Rename `backup` to `core::internal::backup` in `internal/backup.zsh`
- [x] 1.5 Rename `reload` to `core::reload` in `internal/reload.zsh`
- [x] 1.6 Rename `editrc` to `core::editrc` in `internal/editor.zsh`
- [x] 1.7 Rename `editprivaterc` to `core::editprivaterc` in `internal/editor.zsh`
- [x] 1.8 Rename `editcustomrc` to `core::editcustomrc` in `internal/editor.zsh`

## 2. Consolidate Duplicate Reload Implementation

- [x] 2.1 Add platform detection to `core::reload` in `internal/reload.zsh`
- [x] 2.2 Implement macOS-specific behavior (`exec "${SHELL}" -l`) in `core::reload`
- [x] 2.3 Implement Linux-specific behavior (`exec "${SHELL}"`) in `core::reload`
- [x] 2.4 Remove duplicate `reload` function definition from `internal/osx.zsh`

## 3. Update bin/ Files

- [x] 3.1 Update `bin/path_prepend` to call `core::path::prepend` instead of `path::prepend`
- [x] 3.2 Update `bin/path_append` to call `core::path::append` instead of `path::append`
- [x] 3.3 Update `bin/dotfiles::upgrade` to call `core::internal::backup` instead of `backup` (3 occurrences)

## 4. Update Other Callers

- [x] 4.1 Find all callers of `path::prepend` in zsh/ using grep/ripgrep
- [x] 4.2 Update all `path::prepend` callers to `core::path::prepend`
- [x] 4.3 Find all callers of `path::append` in zsh/ using grep/ripgrep
- [x] 4.4 Update all `path::append` callers to `core::path::append`
- [x] 4.5 Find all callers of `path::clean` in zsh/ using grep/ripgrep
- [x] 4.6 Update all `path::clean` callers to `core::path::clean`
- [x] 4.7 Find all callers of `backup` function in zsh/ using grep/ripgrep
- [x] 4.8 Update all `backup` callers to `core::internal::backup`
- [x] 4.9 Find all callers of `reload` in zsh/ using grep/ripgrep
- [x] 4.10 Update all `reload` callers to `core::reload`
- [x] 4.11 Find all callers of `editrc` in zsh/ using grep/ripgrep
- [x] 4.12 Update all `editrc` callers to `core::editrc`
- [x] 4.13 Find all callers of `editprivaterc` in zsh/ using grep/ripgrep
- [x] 4.14 Update all `editprivaterc` callers to `core::editprivaterc`
- [x] 4.15 Find all callers of `editcustomrc` in zsh/ using grep/ripgrep
- [x] 4.16 Update all `editcustomrc` callers to `core::editcustomrc`

## 5. Create jasper:: Wrapper Commands in bin/

- [x] 5.1 Create `bin/jasper::reload` that calls `core::reload`
- [x] 5.2 Create `bin/jasper::path::prepend` that calls `core::path::prepend`
- [x] 5.3 Create `bin/jasper::path::append` that calls `core::path::append`
- [x] 5.4 Create `bin/jasper::path::clean` that calls `core::path::clean`
- [x] 5.5 Create `bin/jasper::editrc` that calls `core::editrc`
- [x] 5.6 Create `bin/jasper::editprivaterc` that calls `core::editprivaterc`
- [x] 5.7 Create `bin/jasper::editcustomrc` that calls `core::editcustomrc`
- [x] 5.8 Make all jasper:: wrapper commands executable (chmod +x)

## 6. Verification

- [x] 6.1 Verify no remaining references to old function names using grep
- [x] 6.2 Test `core::path::prepend` functionality
- [x] 6.3 Test `core::path::append` functionality
- [x] 6.4 Test `core::path::clean` functionality
- [x] 6.5 Test `core::internal::backup` functionality
- [x] 6.6 Test `core::reload` on Linux
- [x] 6.7 Test `core::reload` on macOS (if available)
- [x] 6.8 Test `core::editrc` functionality
- [x] 6.9 Test `core::editprivaterc` functionality
- [x] 6.10 Test `core::editcustomrc` functionality
- [x] 6.11 Test `jasper::reload` wrapper
- [x] 6.12 Test `jasper::path::prepend` wrapper
- [x] 6.13 Test `jasper::path::append` wrapper
- [x] 6.14 Test `jasper::path::clean` wrapper
- [x] 6.15 Test `jasper::editrc` wrapper
- [x] 6.16 Test `jasper::editprivaterc` wrapper
- [x] 6.17 Test `jasper::editcustomrc` wrapper

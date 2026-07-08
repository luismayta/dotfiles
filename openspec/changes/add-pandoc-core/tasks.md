## 1. Categorize OS X CORE_PACKAGES + add pandoc

- [x] 1.1 Restructure `zsh/core/config/osx.zsh` `CORE_PACKAGES` into categories with comments
- [x] 1.2 Add `pandoc` to the Document Conversion category

## 2. Categorize Linux CORE_PACKAGES + add pandoc-cli

- [x] 2.1 Restructure `zsh/core/config/linux.zsh` `CORE_PACKAGES` into categories with comments
- [x] 2.2 Add `pandoc-cli` to the Document Conversion category

## 3. Validate

- [ ] 3.1 Verify syntax: `zsh -n zsh/core/config/osx.zsh && zsh -n zsh/core/config/linux.zsh`
- [ ] 3.2 Run `pandoc --version` to confirm binary is accessible (may need `sudo pacman -S ghc-libs pandoc-cli` first)

## 4. Commit

- [ ] 4.1 Commit with message: `feat 🎉 (core): HAD-XX Add pandoc to CORE_PACKAGES and categorize arrays`

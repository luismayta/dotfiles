## Why

Pandoc ("the universal document converter") is a standard CLI tool for converting between markup formats (markdown, HTML, LaTeX, docx, etc.). The old docker alias was already removed from `docker.zsh`, leaving no pandoc integration in the dotfiles.

Además, `CORE_PACKAGES` en `zsh/core/config/` era un array plano sin organización. Siguiendo el patrón de `ZSH_HERDR_INSTALL_PLUGINS` en el módulo herdr, se categorizó por funcionalidad para mejorar legibilidad y mantenibilidad.

## What Changes

1. **`zsh/core/config/osx.zsh`**: Restructured `CORE_PACKAGES` into categories; added `pandoc`
2. **`zsh/core/config/linux.zsh`**: Restructured `CORE_PACKAGES` into categories; added `pandoc-cli`

Categories applied per platform:
| Categoría | macOS | Linux |
|---|---|---|
| Clipboard | — | `wl-clipboard`, `xclip`, `xsel` |
| Shell & Core | `zsh`, `git`, `rsync`, `ksh` | `git`, `gcc`, `rsync`, `zsh`, `ksh` |
| CLI Utilities | `jq`, `ag`, `fd`, `ripgrep` | `fd`, `ripgrep` |
| Fonts | 3 nerd fonts | 3 nerd fonts |
| Build & Dev Tools | `cmake`, `direnv` | — |
| Build Dependencies | — | `webkit2gtk-4.1`, `gtk3`, `libsoup3`, `pkgconf`, `base-devel`, `libappindicator-gtk3`
| Audio & Display | — | `pipewire`, `wireplumber`, `xdg-desktop-portal`, `xdg-desktop-portal-hyprland` |
| Media & Utilities | — | `grim`, `slurp`, `ffmpeg`, `p7zip`, `poppler`, `fd`, `ueberzugpp` |
| File Management | — | `dolphin`, `direnv`, `udisks2`, `udiskie` |
| Document Conversion | `pandoc` | `pandoc-cli` |

## Capabilities

### New Capabilities
- Pandoc auto-installed via `core::packages::install` on both platforms
- Categorized `CORE_PACKAGES` for readability

### Modified Capabilities
*(none — same packages, same behavior)*

## Impact

- **`zsh/core/config/osx.zsh`**: Restructured array + `pandoc` added
- **`zsh/core/config/linux.zsh`**: Restructured array + `pandoc-cli` added
- **Dependencies**: System package manager handles it (paru on Arch, brew on macOS)
- **Backward compatibility**: Full — package set is identical (plus pandoc), just reorganized

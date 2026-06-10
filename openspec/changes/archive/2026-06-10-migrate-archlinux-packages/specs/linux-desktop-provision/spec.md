## ADDED Requirements

### Requirement: desktop packages migrated from archlinux.sh

The `provision/script/desktop.sh` SHALL contain ALL desktop environment packages previously in `archlinux.sh`, organized by category: window manager, audio, notifications, theming, fonts, file management, PDF, and utilities.

#### Scenario: Desktop script contains i3 packages
- **WHEN** a user sources `provision/script/desktop.sh` on Arch/CachyOS
- **THEN** it SHALL install i3-gaps and i3blocks-gaps-git via `paru -S --noconfirm`

#### Scenario: Desktop script contains audio packages
- **WHEN** a user sources `provision/script/desktop.sh`
- **THEN** it SHALL install alsa-utils, pulseaudio, pulseaudio-alsa, pulseaudio-jack, jack2, pavucontrol, and playerctl

#### Scenario: Desktop script contains theming packages
- **WHEN** a user sources `provision/script/desktop.sh`
- **THEN** it SHALL install gtk-chtheme, arc-gtk-theme, lxappearance, and fonts (ttf-* packages)

#### Scenario: Desktop script contains app packages
- **WHEN** a user sources `provision/script/desktop.sh`
- **THEN** it SHALL install rofi, dunst, feh, flameshot, thunar, thunar-volman, compton, arandr, cups, flatpak, neovim, pandoc, speedcrunch, termite, zathura, zathura-pdf-poppler, graphviz, python2-lxml, python2-scour, and qjackctl

### Requirement: functions.sh sources desktop.sh

The `provision/script/functions.sh` `dotfiles_install_factory` function SHALL source `provision/script/desktop.sh` instead of `archlinux.sh`.

#### Scenario: dotfiles_install_factory sources desktop.sh
- **WHEN** `dotfiles_install_factory` is called on Linux with `paru` available
- **THEN** it SHALL source `"${HOME}/.dotfiles"/provision/script/desktop.sh`
- **AND** it SHALL NOT source `archlinux.sh`

### Requirement: archlinux.sh is removed

The `archlinux.sh` file SHALL be removed from the repository after all its packages are migrated.

#### Scenario: archlinux.sh does not exist
- **WHEN** the repository is cloned fresh
- **THEN** `archlinux.sh` SHALL NOT exist in the project root

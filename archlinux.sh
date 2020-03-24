#!/bin/bash
go get github.com/Jguer/yay

packages=(
    alsa-utils          # audio mixer
    arandr              # graphical screen manamgement
    autojump            # jump
    compton             # compositing
    cups                # printer
    dunst               # notifications
    fd                  # find
    feh                 # image display
    flameshot           # screenshot
    flatpak             # apps
    git
    graphviz
    gtk-chtheme         # gtk theming
    arc-gtk-theme       # arc theme
    i3-gaps
    i3blocks-gaps-git
    jack2               # audio
    jq
    lxappearance        # gtk themeing
    neovim
    pandoc
    pavucontrol         # audio control
    playerctl           # receive media controls
    pulseaudio          # audio
    pulseaudio-alsa
    pulseaudio-jack
    python2-lxml
    python2-scour
    qjackctl
    rofi                # app runner
    speedcrunch         # calculator
    termite             # terminal
    the_silver_searcher
    thunar              # file manager
    thunar-volman
    tmux
    tree
    ttf-inconsolata-g
    ttf-meslo
    ttf-monaco
    ttf-ms-fonts
    xclip
    zathura             # pdf viewer
    zathura-pdf-poppler # pdf pluggin
    zsh
)

for package in "${packages[@]}"; do
    yay -S --noconfirm "${package}"
done

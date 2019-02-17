#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "${SCRIPT_DIR}/bootstrap.sh" ] && source "${SCRIPT_DIR}/bootstrap.sh"

cat <<EOF

-----------------------------
  Brew Install Applications
-----------------------------

EOF

brew update

brew install coreutils \
     shellcheck \
     ispell \
     hunspell \
     asciinema \
     moreutils \
     findutils \
     gnu-sed \
     bash \
     bash-completion2 \
     the_silver_searcher \
     editorconfig \
     aspell \
     libevent libev docker-clean \
     markdown \
     vim \
     openssh \
     git git-lfs git-flow lynx p7zip tig unrar ncdu \
     rename ssh-copy-id tree telnet grep \
     htop \
     peco terminal-notifier packer terragrunt aws-shell \
     ctags \
     global \
     wget \
     jq \
     fzf \
     reattach-to-user-namespace

brew cask install java \
     aws-vault \
     meld \
     docker \
     insomnia \
     kap \
     dash \
     alacritty \
     zazu \
     "1password-cli"

ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Switch to using brew-installed bash as default shell
if ! grep -Fq '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
fi;

# Remove outdated versions from the cellar.
brew cleanup

cat <<EOF

------------------------------------
 Brew Applications installed! Enjoy!
------------------------------------

EOF

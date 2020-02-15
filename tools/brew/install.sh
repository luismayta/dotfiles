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
     global \
     wget \
     jq \
     fzf \
     reattach-to-user-namespace \
     ctags

brew cask install \
     docker \
     alacritty

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

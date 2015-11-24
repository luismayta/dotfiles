#!/usr/bin/env zsh

# Force rehash when command not found
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}

unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
unsetopt FLOWCONTROL
setopt AUTO_MENU         # show completion menu on succesive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# ignore case
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# matches case insensitive for lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# menu if nb items > 2
#zstyle ':completion:*' menu select=2

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-${HOME}}"

# Don't complete uninteresting users
# zstyle ':completion:*:*:*:users' ignored-patterns \
#         adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
#         clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
#         gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
#         ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
#         named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
#         operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
#         rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
#         usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
#zstyle '*' single-ignored show

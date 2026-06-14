#
# shellcheck shell=bash
# Linux helpers — guarded by platform check
#

if ! core::exists xclip; then core::install xclip; fi

open() {
  if [ -e /usr/bin/xdg-open ]; then
    xdg-open "${1}"
  fi
}

pbcopy() {
  if type xclip > /dev/null; then xclip -selection clipboard; fi
  if type xsel > /dev/null; then xsel --clipboard --input; fi
}

pbpaste() {
  if type xclip > /dev/null; then xclip -selection clipboard -o; fi
  if type xsel > /dev/null; then xsel --clipboard --output; fi
}

core::fix::audio() {
  systemctl --user restart wireplumber pipewire pipewire-pulse
}
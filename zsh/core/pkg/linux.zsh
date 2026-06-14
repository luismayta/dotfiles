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

pbcopy () {
	if type wl-copy > /dev/null
	then
		wl-copy
	elif type xclip > /dev/null
	then
		xclip -selection clipboard
	elif type xsel > /dev/null
	then
		xsel --clipboard --input
	else
		echo "pbcopy: no clipboard tool found (install wl-clipboard, xclip or xsel)" >&2
		return 1
	fi
}

pbpaste() {
	if type wl-paste > /dev/null
	then
		wl-paste
	elif type xclip > /dev/null
	then
		xclip -selection clipboard -o
	elif type xsel > /dev/null
	then
		xsel --clipboard --output
	else
		echo "pbpaste: no clipboard tool found (install wl-clipboard, xclip or xsel)" >&2
		return 1
	fi
}

core::fix::audio() {
  systemctl --user restart wireplumber pipewire pipewire-pulse
}
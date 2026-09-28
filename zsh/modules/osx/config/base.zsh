# shellcheck shell=bash
#
# osx module configuration.
#
# Every variable carries the ZSH_OSX_ prefix, per docs/guides/create-module.md
# section 8: the prefix namespaces this module against collisions with external
# tooling. The unprefixed legacy style still used by zed, nvim and apps is
# historical debt and is deliberately not followed here.
#

ZSH_OSX_ENABLED="${ZSH_OSX_ENABLED:-true}"

# ============ Paths ============
export ZSH_OSX_DATA_PATH="${ZSH_OSX_PATH}/data"
export ZSH_OSX_MIGRATION_INVENTORY="${ZSH_OSX_DATA_PATH}/migration-inventory.yaml"

# Hostname operations. Empty on purpose: the source repo references its backing
# variable four times and assigns it zero times, so a naive migration would run
# `scutil --set ComputerName ""`, which is not a no-op — it erases the configured
# network name. The renderer reports an empty value as `skipped`, not
# `documented`, which is what produces the 8/4 split.
export ZSH_OSX_COMPUTER_NAME="${ZSH_OSX_COMPUTER_NAME:-}"

# ============ Gates ============
#
# ZSH_OSX_DESTRUCTIVE is the kill switch: while it is false the destructive
# operations are not available at all, and the report-and-return-1 path is
# taken without prompting. Its false default is what makes an irreversible
# operation unreachable by accident.
export ZSH_OSX_CONFIRM="${ZSH_OSX_CONFIRM:-true}"
export ZSH_OSX_DESTRUCTIVE="${ZSH_OSX_DESTRUCTIVE:-false}"
export ZSH_OSX_FORCE="${ZSH_OSX_FORCE:-false}"
export ZSH_OSX_REFRESH="${ZSH_OSX_REFRESH:-true}"

# ============ Privileged operations ============
#
# The 12 operations this module documents but never executes: the module must
# not run sudo, so each one is reported as a manual procedure. Data, not code —
# one row per operation, rendered by a single loop in internal/privileged.zsh.
#
# Six colon-separated fields, read back with ${(s.:.)value}:
#
#   origin  — source line number in zsh-osx/internal/base.zsh
#   target  — plist path or defaults domain; `-` for nvram/systemsetup/scutil
#   key     — the preference key, or the tool's option name
#   type    — the type flag the source line actually uses (-bool / -int /
#             -string), or -flag for lines that take no defaults type flag
#   value   — the value the source writes
#   command — the full command the user runs by hand
#
# CONSTRAINT: no field may contain a colon, because colon is the field
# separator. All 12 command values are colon-free as written. The four hostname
# commands stay colon-free only because ZSH_OSX_COMPUTER_NAME is empty or a
# plain name; a user-chosen name containing a colon would break the split.
#
# A missing target is written `-` and never left blank. zsh's `(s.:.)` split
# discards empty fields rather than yielding them, so a blank target would
# silently collapse the row to five fields and shift every later field one
# position left — the renderer indexes positionally, so the blank form is not
# merely untidy, it reads the wrong column.
#
# Every entry is single-quoted, so the `${ZSH_OSX_COMPUTER_NAME}` in the value
# field is stored verbatim as text and is expanded by the renderer in
# internal/privileged.zsh, not by the shell that sources this file. That late
# expansion is the whole point: the renderer can expand it, find the result
# empty, and report the operation as `skipped` instead of `documented`.
# Double-quoting these rows would expand the variable here, at load time, and an
# empty result would vanish into the field entirely.
typeset -gA ZSH_OSX_PRIVILEGED_OPS
# shellcheck disable=SC2034 # consumed by internal/privileged.zsh
# shellcheck disable=SC2016 # the single quotes are deliberate: the renderer expands
ZSH_OSX_PRIVILEGED_OPS=(
  [software-update-auto-install]='363:/Library/Preferences/com.apple.SoftwareUpdate.plist:AutomaticallyInstallMacOSUpdates:-bool:true:sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true'
  [software-update-automatic-check]='364:/Library/Preferences/com.apple.SoftwareUpdate.plist:AutomaticCheckEnabled:-bool:true:sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true'
  [software-update-automatic-download]='365:/Library/Preferences/com.apple.SoftwareUpdate.plist:AutomaticDownload:-bool:true:sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true'
  [software-update-config-data-install]='366:/Library/Preferences/com.apple.SoftwareUpdate.plist:ConfigDataInstall:-bool:true:sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true'
  [software-update-critical-install]='367:/Library/Preferences/com.apple.SoftwareUpdate.plist:CriticalUpdateInstall:-bool:true:sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true'
  [commerce-auto-update]='368:/Library/Preferences/com.apple.commerce.plist:AutoUpdate:-bool:true:sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true'
  [mute-startup-chime]='482:-:SystemAudioVolume:-flag: :sudo nvram SystemAudioVolume=" "'
  [restart-freeze]='488:-:setrestartfreeze:-flag:on:sudo systemsetup -setrestartfreeze on'
  [computer-name]='498:-:ComputerName:-flag:${ZSH_OSX_COMPUTER_NAME}:sudo scutil --set ComputerName "${ZSH_OSX_COMPUTER_NAME}"'
  [host-name]='499:-:HostName:-flag:${ZSH_OSX_COMPUTER_NAME}:sudo scutil --set HostName "${ZSH_OSX_COMPUTER_NAME}"'
  [localhost-name]='500:-:LocalHostName:-flag:${ZSH_OSX_COMPUTER_NAME}:sudo scutil --set LocalHostName "${ZSH_OSX_COMPUTER_NAME}"'
  [netbios-name]='501:/Library/Preferences/SystemConfiguration/com.apple.smb.server:NetBIOSName:-string:${ZSH_OSX_COMPUTER_NAME}:sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${ZSH_OSX_COMPUTER_NAME}"'
)

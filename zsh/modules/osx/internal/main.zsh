# shellcheck shell=bash
#
# osx / internal / main — the internal layer of the osx module.
#
# Five area files, loaded unconditionally, in a fixed order, with no platform
# dispatch. Two deliberate choices:
#
# 1. Unconditional, and no platform branch. A branch here would have zero live
#    arms: the platform decision was already made one layer up, where the Linux
#    config sets ZSH_OSX_ENABLED=false and plugin.zsh returns on that before
#    this file is ever reached. Deciding it again would be a second authority
#    for a question that already has an answer. This follows the precedent in
#    modules/apps/internal/main.zsh, where the unconditional lines come first
#    and the platform branch starts after them.
#
# 2. Fixed order. The areas have no ordering requirement of their own — they
#    only define functions, and none of them runs at load time. Keeping host,
#    privileged and destructive together, with the process-touching refresh
#    area last, means a reader who reaches the end of the file has just read
#    the one area that can affect the desktop session.
#
# There is no base file for this layer either: these five files are all of it.
# Loading this file restarts nothing and runs no operation of its own.
#
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/host.zsh"
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/privileged.zsh"
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/destructive.zsh"
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/refresh.zsh"
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/screenlock.zsh"

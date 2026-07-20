# shellcheck shell=bash
# Public API: MPD module

mpd::install() {
  mpd::internal::install
}

mpd::start() {
  mpd::internal::load
}

mpd::stop() {
  mpd::internal::stop
}

mpd::status() {
  mpd::internal::status
}

mpd::play() {
  mpc play
}

mpd::pause() {
  mpc pause
}

mpd::stop-playback() {
  mpc stop
}

mpd::next() {
  mpc next
}

mpd::prev() {
  mpc prev
}

mpd::toggle() {
  mpc toggle
}

mpd::current() {
  mpc current
}

mpd::playlist() {
  mpc playlist
}

mpd::volume() {
  mpc volume "$@"
}

mpd::ncmpcpp() {
  ncmpcpp "$@"
}

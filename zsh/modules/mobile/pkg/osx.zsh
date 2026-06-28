# shellcheck shell=bash
# mobile module — macOS public API (iOS tooling)

# --- iOS ---

function ios::install {
    mobile::internal::ios::install
}

function ios::load {
    mobile::internal::ios::load
}

function ios::upgrade {
    mobile::internal::ios::upgrade
}

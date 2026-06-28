# shellcheck shell=bash
# mobile module — public API

# --- Android ---

function android::install {
    mobile::internal::android::install
}

function android::load {
    mobile::internal::android::load
}

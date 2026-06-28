# shellcheck shell=bash
# mobile module — public API

# --- Android ---

function android::install {
    mobile::internal::android::install
}

function android::load {
    mobile::internal::android::load
}

# --- Flutter ---

function flutter::install {
    mobile::internal::flutter::install
}

function flutter::load {
    mobile::internal::flutter::load
}

function flutter::post_install {
    message_info "Post Install ${FLUTTER_PACKAGE_NAME}"
    mobile::internal::flutter::post_install
    message_success "Post Install ${FLUTTER_PACKAGE_NAME}"
}

function flutter::upgrade {
    mobile::internal::flutter::upgrade
}

function flutter::dependences {
    core::ensure curl
    core::ensure git
    core::ensure unzip
    message_success "${FLUTTER_PACKAGE_NAME} dependencies satisfied."
}

function flutter::purge {
    message_warning "Removing ${FLUTTER_ROOT}..."
    rm -rf "${FLUTTER_ROOT}"
    message_success "${FLUTTER_PACKAGE_NAME} SDK removed."
}

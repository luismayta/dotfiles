# shellcheck shell=bash

function resources::fonts::sync {
    rsync -avzh --progress "${RESOURCES_DATA_PATH}/fonts/" "${RESOURCES_FONTS_PATH}/"
    if type -p fc-cache > /dev/null; then
        fc-cache -f "${RESOURCES_FONTS_PATH}"
    fi
}

#!/usr/bin/env bash
set -euo pipefail

BOARD=seeeduino_xiao_ble
SHIELD=ctrl

# --------------------

cd /work

OUTDIR="$(pwd)/build"
CONFIG_PATH="config"

BUILD_DIR="$(mktemp -d)"

ZMK_LOAD_ARG="-DZMK_EXTRA_MODULES=$(pwd)"
#BASEDIR="$(pwd)"
BASEDIR="/tmp/zmk-config"

EXTRA_CMAKE_ARGS=("${SHIELD:+-DSHIELD="$SHIELD"}" "$ZMK_LOAD_ARG")

# --------------------

rm -rf "${BASEDIR:?}/${CONFIG_PATH}"
mkdir "${BASEDIR}/${CONFIG_PATH}"
cp -R "${CONFIG_PATH}"/* "${BASEDIR}/${CONFIG_PATH}/"

# --------------------

function log() {
  echo -e "\e[36m" "$@" "\e[39m"
}
function run() {
    printf " \e[36mexec:"
    for arg in "$@"; do
        printf " %q" "$arg"
    done
    printf "\e[39m\n"

    command "$@"
}

# --------------------

run cd "${BASEDIR}"

# --------------------

if [ ! -d ".west" ]; then
  run west init -l "${BASEDIR}/${CONFIG_PATH}"
fi

# --------------------

run west update --fetch-opt=--filter=tree:0

# --------------------

run west zephyr-export

# --------------------

mkdir -p "${OUTDIR}"
rm -rf "${OUTDIR:?}"/*

#  --snippet zmk-usb-logging
run west build -s zmk/app --build-dir "${BUILD_DIR}" --board "${BOARD}" -- -DZMK_CONFIG="${BASEDIR}/${CONFIG_PATH}" "${EXTRA_CMAKE_ARGS[@]}" || cp -R "${BUILD_DIR}/zephyr" "${OUTDIR}"

# --------------------

cp "${BUILD_DIR}/zephyr/zmk.uf2" "${BUILD_DIR}/zephyr/zephyr.dts" "${OUTDIR}"

# --------------------

log "Firmware artifacts copied to $OUTDIR"
ls -1A "$OUTDIR"

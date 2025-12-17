#!/usr/bin/env bash
set -euo pipefail

BOARD=seeeduino_xiao_ble
SHIELD=ctrl

# --------------------

cd /work

BUILD_DIR="$(mktemp -d)"
BASEDIR="$(pwd)"
OUTDIR="$(pwd)/build"
EXTRA_CMAKE_ARGS=("${SHIELD:+-DSHIELD="$SHIELD"}")
CONFIG_PATH="config"

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

if [ ! -d ".west" ]; then
  log "Running: west init"
  run west init -l "${BASEDIR}/${CONFIG_PATH}"
fi

# --------------------

log "Running: west update"
run west update --fetch-opt=--filter=tree:0

# --------------------

log "Running: west zephyr-export"
run west zephyr-export

# --------------------

log "Building for board: $BOARD"
run west build -s zmk/app -d "${BUILD_DIR}" -b "${BOARD}" -- -DZMK_CONFIG="${BASEDIR}/${CONFIG_PATH}" "${EXTRA_CMAKE_ARGS[@]}"

# --------------------

mkdir -p "${OUTDIR}"
rm -rf "${OUTDIR:?}"/*

cp "${BUILD_DIR}/zephyr/zmk.uf2" "${OUTDIR}"

# --------------------

log "Firmware artifacts copied to $OUTDIR"
ls -1A "$OUTDIR"
